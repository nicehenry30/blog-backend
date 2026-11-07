<?php

namespace App\Services\News;

class NewsInstrumentRelevanceService
{
    public function detect(array $article): array
    {
        $text = strtolower(
            ($article['title'] ?? '') . ' ' .
            ($article['description'] ?? '')
        );

        $matches = [];

        $keywords = [
            'XAUUSD' => [
                'gold',
                'bullion',
                'precious metal',
            ],

            'XAGUSD' => [
                'silver',
            ],

            'WTI' => [
            'wti',
            'west texas intermediate',
            ],

            'BRENT' => [
                'brent',
                'brent crude',
            ],

            'EURUSD' => [
                'eurusd',
                'euro',
                'eur/usd',
                'euro dollar',
            ],

            'GBPUSD' => [
                'gbpusd',
                'british pound',
                'pound sterling',
                'gbp/usd',
            ],

            'USDJPY' => [
                'usdjpy',
                'yen',
                'japanese yen',
                'usd/jpy',
            ],

            'USDCHF' => [
                'usdchf',
                'swiss franc',
                'usd/chf',
            ],

            'USDCAD' => [
                'usdcad',
                'canadian dollar',
                'usd/cad',
            ],

            'AUDUSD' => [
                'audusd',
                'australian dollar',
                'aud/usd',
            ],

            'NZDUSD' => [
                'nzdusd',
                'new zealand dollar',
                'nzd/usd',
            ],
        ];

        foreach ($keywords as $symbol => $terms) {
            foreach ($terms as $term) {
                if (str_contains($text, strtolower($term))) {
                    $matches[] = $symbol;
                    break;
                }
            }
        }

        return array_values(array_unique($matches));
    }
}