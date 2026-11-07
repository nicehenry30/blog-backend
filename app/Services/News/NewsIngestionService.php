<?php

namespace App\Services\News;

class NewsIngestionService
{
    public function __construct(
        private MarketauxNewsProvider $provider,
        private NewsPersistenceService $persistence,
    ) {
    }

    public function ingest(array $params = []): int
    {
        $data = $this->provider->fetch($params);

        $articles = $data['data'] ?? [];

        $persisted = 0;

        foreach ($articles as $article) {
            if (!is_array($article) || empty($article['uuid'])) {
                continue;
            }

            $this->persistence->persist($article);

            $persisted++;
        }

        return $persisted;
    }
}