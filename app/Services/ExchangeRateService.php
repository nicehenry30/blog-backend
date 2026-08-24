<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use RuntimeException;

class ExchangeRateService
{
    /**
     * Convert an amount from USD to another currency
     * using a live exchange rate.
     */
    public function convertFromUsd(
        float $usdAmount,
        string $targetCurrency
    ): float {
        $targetCurrency = strtoupper(trim($targetCurrency));

        /*
         * No conversion required.
         */
        if ($targetCurrency === 'USD') {
            return round($usdAmount, 2);
        }

        try {
            $response = Http::timeout(15)
                ->acceptJson()
                ->get(
                    'https://open.er-api.com/v6/latest/USD'
                );

            if (! $response->successful()) {
                throw new RuntimeException(
                    'Exchange rate API failed. ' .
                    'HTTP status: ' .
                    $response->status() .
                    ' Response: ' .
                    $response->body()
                );
            }

            $data = $response->json();

            /*
             * Verify that the API returned a valid response.
             */
            if (
                ! isset($data['result']) ||
                $data['result'] !== 'success'
            ) {
                throw new RuntimeException(
                    'Exchange rate API returned an invalid response.'
                );
            }

            /*
             * Make sure the requested currency exists.
             */
            if (
                ! isset($data['rates']) ||
                ! isset($data['rates'][$targetCurrency])
            ) {
                throw new RuntimeException(
                    "Exchange rate for USD to {$targetCurrency} " .
                    'is unavailable.'
                );
            }

            $rate = (float) $data['rates'][$targetCurrency];

            if ($rate <= 0) {
                throw new RuntimeException(
                    'Invalid exchange rate received.'
                );
            }

            return round(
                $usdAmount * $rate,
                2
            );

        } catch (\Throwable $e) {

            /*
             * Preserve our useful error messages.
             */
            if ($e instanceof RuntimeException) {
                throw $e;
            }

            throw new RuntimeException(
                'Unable to retrieve the current exchange rate. ' .
                $e->getMessage()
            );
        }
    }
}