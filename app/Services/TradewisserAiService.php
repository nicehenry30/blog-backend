<?php

namespace App\Services;

use Illuminate\Http\Client\ConnectionException;
use Illuminate\Support\Facades\Http;
use RuntimeException;

class TradewisserAiService
{
    /**
     * Send a market-analysis request to the internal
     * Python Tradewisser AI service.
     */
    public function analyze(
        string $symbol,
        float $accountBalance,
        float $riskPercent
    ): array {
        $baseUrl = rtrim(
            config('services.tradewisser_ai.url'),
            '/'
        );

        try {
            $response = Http::timeout(120)
                ->acceptJson()
                ->post(
                    $baseUrl . '/analyze',
                    [
                        'symbol' => $symbol,
                        'account_balance' => $accountBalance,
                        'risk_percent' => $riskPercent,
                    ]
                );
        } catch (ConnectionException $exception) {
            throw new RuntimeException(
                'Unable to connect to the Tradewisser AI service.',
                0,
                $exception
            );
        }

        if ($response->failed()) {
            throw new RuntimeException(
                'Tradewisser AI returned HTTP '
                . $response->status()
                . ': '
                . $response->body()
            );
        }

        $data = $response->json();

        if (!is_array($data)) {
            throw new RuntimeException(
                'Tradewisser AI returned an invalid response.'
            );
        }

        return $data;
    }

    /**
     * Check whether the Python AI service is available.
     */
    public function health(): array
    {
        $baseUrl = rtrim(
            config('services.tradewisser_ai.url'),
            '/'
        );

        try {
            $response = Http::timeout(10)
                ->acceptJson()
                ->get($baseUrl . '/health');
        } catch (ConnectionException $exception) {
            throw new RuntimeException(
                'Unable to connect to the Tradewisser AI service.',
                0,
                $exception
            );
        }

        if ($response->failed()) {
            throw new RuntimeException(
                'Tradewisser AI health check failed with HTTP '
                . $response->status()
            );
        }

        return $response->json();
    }
}