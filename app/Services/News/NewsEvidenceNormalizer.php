<?php

namespace App\Services\News;

use App\Models\NewsEvidence;

class NewsEvidenceNormalizer
{
    public function normalize(array $article): array
    {
        $evidence = [];

        foreach ($article['entities'] ?? [] as $entity) {
            if (!is_array($entity)) {
                continue;
            }

            $symbol = strtoupper($entity['symbol'] ?? '');

            if (!$this->isSupportedSymbol($symbol)) {
                continue;
            }

            $evidence[] = new NewsEvidence(
                symbol: $symbol,
                title: $article['title'] ?? '',
                url: $article['url'] ?? '',
                source: $article['source'] ?? null,
                publishedAt: $article['published_at'] ?? null,
                sentimentScore: isset($entity['sentiment_score'])
                    ? (float) $entity['sentiment_score']
                    : null,
                matchScore: isset($entity['match_score'])
                    ? (float) $entity['match_score']
                    : null,
                highlights: $entity['highlights'] ?? [],
            );
        }

        return $evidence;
    }

    private function isSupportedSymbol(string $symbol): bool
    {
        $supportedSymbols = collect(config('market_instruments'))
            ->flatten()
            ->filter(fn ($value) => is_string($value))
            ->map(fn ($value) => strtoupper($value))
            ->unique()
            ->values()
            ->all();

        return in_array($symbol, $supportedSymbols, true);
    }
}