<?php

namespace Tests\Unit;

use App\Models\News;
use App\Models\NewsEvidenceRecord;
use App\Services\News\NewsPersistenceService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class NewsPersistenceServiceTest extends TestCase
{
    use RefreshDatabase;

    public function test_it_persists_news_and_instrument_evidence(): void
    {
        $service = app(NewsPersistenceService::class);

        $article = [
            'uuid' => 'test-news-evidence-001',
            'title' => 'EUR/USD and USD/JPY market outlook',
            'description' => 'Forex market outlook.',
            'url' => 'https://example.com/test-news-evidence-001',
            'source' => 'Test Source',
            'published_at' => '2026-10-30T15:00:00Z',
            'image_url' => null,
            'currencies' => [],
            'entities' => [
                [
                    'symbol' => 'EURUSD',
                    'sentiment_score' => 0.40,
                    'match_score' => 100.0,
                    'highlights' => [
                        [
                            'highlight' => 'EUR/USD outlook remains positive.',
                            'sentiment' => 0.62,
                            'highlighted_in' => 'main_text',
                        ],
                    ],
                ],
                [
                    'symbol' => 'USDJPY',
                    'sentiment_score' => -0.25,
                    'match_score' => 90.0,
                    'highlights' => [],
                ],
                [
                    'symbol' => 'CADTOP',
                    'sentiment_score' => 0.50,
                    'match_score' => 50.0,
                    'highlights' => [],
                ],
            ],
            'sentiment' => null,
            'sentiment_score' => null,
        ];

        $news = $service->persist($article);

        $this->assertInstanceOf(News::class, $news);
        $this->assertDatabaseHas('news', [
            'marketaux_uuid' => 'test-news-evidence-001',
        ]);

        $this->assertDatabaseCount('news_evidence', 2);

        $eurusdEvidence = NewsEvidenceRecord::query()
            ->where('news_id', $news->id)
            ->where('symbol', 'EURUSD')
            ->first();

        $this->assertNotNull($eurusdEvidence);
        $this->assertSame(0.40, $eurusdEvidence->sentiment_score);
        $this->assertSame(100.0, $eurusdEvidence->match_score);
        $this->assertSame(
            0.62,
            $eurusdEvidence->highlights[0]['sentiment']
        );

        $this->assertDatabaseHas('news_evidence', [
            'news_id' => $news->id,
            'symbol' => 'USDJPY',
        ]);

        $this->assertDatabaseMissing('news_evidence', [
            'news_id' => $news->id,
            'symbol' => 'CADTOP',
        ]);
    }
}