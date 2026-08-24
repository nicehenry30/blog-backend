<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use RuntimeException;

class CurrencyService
{
    /**
     * Convert an amount between currencies.
     *
     * USD remains the source/pricing currency
     * for Tradewisser subscriptions.
     */
    public function convert(
        float $amount,
        string $from,
        string $to
    ): float {
        $from = strtoupper($from);
        $to = strtoupper($to);

        if ($from === $to) {
            return round($amount, 2);
        }

        /*
         * We will replace this with the selected
         * exchange-rate provider configuration.
         */
        $response = Http::timeout(15)
            ->acceptJson()
            ->get(
                'https://open.er-api.com/v6/latest/'
                . $from
            );

        if (! $response->successful()) {
            throw new RuntimeException(
                'Unable to retrieve exchange rate.'
            );
        }

        $data = $response->json();

        if (
            ! isset($data['rates']) ||
            ! isset($data['rates'][$to])
        ) {
            throw new RuntimeException(
                "Exchange rate {$from} to {$to} is unavailable."
            );
        }

        $rate = (float) $data['rates'][$to];

        return round(
            $amount * $rate,
            2
        );
    }
}