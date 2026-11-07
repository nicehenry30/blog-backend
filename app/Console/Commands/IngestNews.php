<?php

namespace App\Console\Commands;

use App\Services\News\NewsIngestionService;
use Illuminate\Console\Command;

class IngestNews extends Command
{
    protected $signature = 'news:ingest {--limit=20 : Number of articles to ingest}';

    protected $description = 'Fetch and persist financial news from Marketaux';

    public function handle(NewsIngestionService $ingestion): int
    {
        $limit = min(
            max((int) $this->option('limit'), 1),
            100
        );

        $this->info("Fetching up to {$limit} news articles...");

        try {
            $count = $ingestion->ingest([
                'limit' => $limit,
            ]);
        } catch (\Throwable $exception) {
            $this->error(
                'News ingestion failed: ' . $exception->getMessage()
            );

            return self::FAILURE;
        }

        $this->info(
            "Successfully ingested {$count} article(s)."
        );

        return self::SUCCESS;
    }
}