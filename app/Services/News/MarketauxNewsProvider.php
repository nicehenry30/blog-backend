<?php

namespace App\Services\News;

use Illuminate\Http\Client\ConnectionException;
use Illuminate\Support\Facades\Http;
use RuntimeException;

class MarketauxNewsProvider
{
    private const BASE_URL = 'https://api.marketaux.com/v1/news/all';

    public function fetch(array $params = []): array
    {
        $apiKey = config('services.marketaux.api_key');

        if (!$apiKey) {
            throw new RuntimeException(
                'MARKETAUX_API_KEY is not configured.'
            );
        }

        try {
            $response = Http::timeout(30)
            ->retry(1, 1000)
            ->get(self::BASE_URL, array_merge(
  
                    [
                        'api_token' => $apiKey,
                        'language' => 'en',
                    ],
                    $params
                ));
        } catch (ConnectionException $exception) {
            throw new RuntimeException(
                'Unable to connect to Marketaux: ' . $exception->getMessage(),
                0,
                $exception
            );
        }

        if ($response->failed()) {
            throw new RuntimeException(
                'Marketaux request failed with HTTP status '
                . $response->status()
                . '.'
            );
        }

        $data = $response->json();

        if (!is_array($data)) {
            throw new RuntimeException(
                'Marketaux returned an invalid response.'
            );
        }

        return $data;
    }
}