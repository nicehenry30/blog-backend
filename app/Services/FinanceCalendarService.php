<?php

namespace App\Services;

use Illuminate\Http\Client\ConnectionException;
use Illuminate\Support\Facades\Http;
use RuntimeException;

class FinanceCalendarService
{
    private const BASE_URL = 'https://www.financecalendar.com/wp-json/fc/v1/calendar';

    /**
     * Fetch economic calendar events from Finance Calendar.
     */
    public function fetch(array $filters = []): array
    {
        $apiKey = config('services.finance_calendar.api_key');

        if (! $apiKey) {
            throw new RuntimeException(
                'FINANCE_CALENDAR_API_KEY is not configured.'
            );
        }

        try {
            $response = Http::timeout(30)
                ->acceptJson()
                ->withHeaders([
                    'X-API-Key' => $apiKey,
                ])
                ->get(self::BASE_URL, $filters);
        } catch (ConnectionException $exception) {
            throw new RuntimeException(
                'Unable to connect to Finance Calendar: '.$exception->getMessage(),
                0,
                $exception
            );
        }

        if ($response->failed()) {
            throw new RuntimeException(
                'Finance Calendar request failed with HTTP status '
                .$response->status().': '
                .$response->body()
            );
        }

        $data = $response->json();

        if (! is_array($data)) {
            throw new RuntimeException(
                'Finance Calendar returned an invalid response.'
            );
        }

        return $data;
    }
}