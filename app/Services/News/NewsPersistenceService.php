<?php

namespace App\Services\News;

use App\Models\News;

class NewsPersistenceService
{
    private NewsInstrumentRelevanceService $relevanceService;

    private NewsEvidenceNormalizer $evidenceNormalizer;

    public function __construct(
        NewsInstrumentRelevanceService $relevanceService,
        NewsEvidenceNormalizer $evidenceNormalizer
    ) {
        $this->relevanceService = $relevanceService;
        $this->evidenceNormalizer = $evidenceNormalizer;
    }

    public function persist(array $article): News
    {
        $news = News::updateOrCreate(
            [
                'marketaux_uuid' => $article['uuid'],
            ],
            [
                'title' => $article['title'] ?? '',
                'description' => $article['description'] ?? null,
                'url' => $article['url'] ?? '',
                'source' => $article['source'] ?? null,
                'published_at' => $article['published_at'] ?? null,
                'image_url' => $article['image_url'] ?? null,

                'symbols' => $this->detectSymbols($article),

                'currencies' => $article['currencies'] ?? [],
                'entities' => $article['entities'] ?? [],

                'sentiment' => $article['sentiment'] ?? null,
                'sentiment_score' => $article['sentiment_score'] ?? null,

                'raw_data' => $article,
            ]
        );

        $news->evidence()->delete();

        foreach ($this->evidenceNormalizer->normalize($article) as $evidence) {
            $news->evidence()->create([
                'symbol' => $evidence->symbol,
                'sentiment_score' => $evidence->sentimentScore,
                'match_score' => $evidence->matchScore,
                'highlights' => $evidence->highlights,
            ]);
        }

        return $news;
    }

    private function detectSymbols(array $article): array
    {
        $entitySymbols = $this->extractSupportedSymbols(
            $article['entities'] ?? []
        );

        $keywordSymbols = $this->relevanceService->detect($article);

        return collect([
            ...$entitySymbols,
            ...$keywordSymbols,
        ])
            ->unique()
            ->values()
            ->all();
    }

    private function extractSupportedSymbols(array $entities): array
    {
        $supportedSymbols = collect(config('market_instruments'))
            ->flatten()
            ->filter(fn ($symbol) => is_string($symbol))
            ->map(fn ($symbol) => strtoupper($symbol))
            ->unique()
            ->values()
            ->all();

        return collect($entities)
            ->filter(function ($entity) use ($supportedSymbols) {
                if (!is_array($entity)) {
                    return false;
                }

                $symbol = strtoupper($entity['symbol'] ?? '');

                return in_array($symbol, $supportedSymbols, true);
            })
            ->map(fn ($entity) => strtoupper($entity['symbol']))
            ->unique()
            ->values()
            ->all();
    }
}