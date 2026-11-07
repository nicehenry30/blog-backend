<?php

namespace App\Services;

use App\Models\MarketAlert;
use Carbon\Carbon;

class FinanceCalendarAlertSyncService
{
    public function __construct(
        private FinanceCalendarService $financeCalendarService
    ) {
    }

    /**
     * Import upcoming high-impact economic events
     * into the existing MarketAlert system.
     */
    public function sync(array $filters = []): int
    {
        $filters = array_merge([
            'impact' => 'high',
            'limit' => 50,
        ], $filters);

        $response = $this->financeCalendarService->fetch($filters);

        $events = $response['events'] ?? [];

        $createdOrUpdated = 0;

        foreach ($events as $event) {
            $releaseAt = $event['release_at_utc'] ?? null;

            if (! $releaseAt) {
                continue;
            }

            $alertTime = Carbon::parse($releaseAt);

            if ($alertTime->isPast()) {
                continue;
            }

            $title = $event['title']
                ?? $event['name']
                ?? 'Economic Event';

            $symbol = $this->resolveSymbol($event);

            $impact = strtolower($event['impact'] ?? 'medium');

            if (! in_array($impact, ['low', 'medium', 'high'], true)) {
                $impact = 'medium';
            }

            $recommendation = $this->buildRecommendation(
                $title,
                $impact
            );

            MarketAlert::updateOrCreate(
                [
                    'title' => $title,
                    'alert_time' => $alertTime,
                ],
                [
                    'symbol' => $symbol,
                    'impact' => $impact,
                    'recommendation' => $recommendation,
                    'is_active' => true,
                ]
            );

            $createdOrUpdated++;
        }

        return $createdOrUpdated;
    }

    private function resolveSymbol(array $event): string
    {
        $country = strtoupper(trim($event['country'] ?? ''));

        if (in_array($country, ['US', 'USA', 'UNITED STATES'], true)) {
            return 'USD';
        }

        if (in_array($country, ['GB', 'UK', 'UNITED KINGDOM'], true)) {
            return 'GBP';
        }

        if (in_array($country, ['EU', 'EUROZONE'], true)) {
            return 'EUR';
        }

        if (in_array($country, ['JP', 'JAPAN'], true)) {
            return 'JPY';
        }

        if (in_array($country, ['CA', 'CANADA'], true)) {
            return 'CAD';
        }

        if (in_array($country, ['AU', 'AUSTRALIA'], true)) {
            return 'AUD';
        }

        if (in_array($country, ['NZ', 'NEW ZEALAND'], true)) {
            return 'NZD';
        }

        if (in_array($country, ['CH', 'SWITZERLAND'], true)) {
            return 'CHF';
        }

        return $country !== '' ? $country : 'GLOBAL';
    }

    private function buildRecommendation(
        string $title,
        string $impact
    ): string {
        if ($impact === 'high') {
            return "High-impact economic event: {$title}. Consider increased market volatility around the release time and manage risk accordingly.";
        }

        if ($impact === 'medium') {
            return "Medium-impact economic event: {$title}. Monitor market conditions around the release time.";
        }

        return "Low-impact economic event: {$title}. Monitor the release if it is relevant to your trading strategy.";
    }
}