<?php

namespace Tests\Unit;

use App\Models\NewsEvidence;
use App\Services\News\NewsEvidenceNormalizer;
use Tests\TestCase;

class NewsEvidenceNormalizerTest extends TestCase
{
    public function test_it_normalizes_supported_marketaux_entities(): void
    {
        $normalizer = app(NewsEvidenceNormalizer::class);

        $article = [
            'title' => 'EUR/USD and USD/JPY market outlook',
            'url' => 'https://example.com/test-news',
            'source' => 'Test Source',
            'published_at' => '2026-10-30T15:00:00Z',
            'entities' => [
                [
                    'symbol' => 'EURUSD',
                    'sentiment_score' => 0.40,
                    'match_score' => 100.0,
                    'highlights' => [],
                ],
                [
                    'symbol' => 'USDJPY',
                    'sentiment_score' => -0.25,
                    'match_score' => 90.0,
                    'highlights' => [],
                ],
            ],
        ];

        $evidence = $normalizer->normalize($article);

        $this->assertCount(2, $evidence);
        $this->assertInstanceOf(NewsEvidence::class, $evidence[0]);

        $this->assertSame('EURUSD', $evidence[0]->symbol);
        $this->assertSame(0.40, $evidence[0]->sentimentScore);
        $this->assertSame(100.0, $evidence[0]->matchScore);

        $this->assertSame('USDJPY', $evidence[1]->symbol);
        $this->assertSame(-0.25, $evidence[1]->sentimentScore);
        $this->assertSame(90.0, $evidence[1]->matchScore);
    }

    public function test_it_ignores_unsupported_symbols(): void
    {
        $normalizer = app(NewsEvidenceNormalizer::class);

        $article = [
            'title' => 'Unsupported instrument test',
            'url' => 'https://example.com/test-news',
            'entities' => [
                [
                    'symbol' => 'CADTOP',
                    'sentiment_score' => 0.50,
                    'match_score' => 50.0,
                ],
            ],
        ];

        $evidence = $normalizer->normalize($article);

        $this->assertCount(0, $evidence);
    }

    public function test_it_preserves_highlight_level_sentiment(): void
    {
        $normalizer = app(NewsEvidenceNormalizer::class);

        $article = [
            'title' => 'EUR/USD outlook',
            'url' => 'https://example.com/test-news',
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
                        [
                            'highlight' => 'However, short-term risks remain.',
                            'sentiment' => -0.31,
                            'highlighted_in' => 'main_text',
                        ],
                    ],
                ],
            ],
        ];

        $evidence = $normalizer->normalize($article);

        $this->assertCount(1, $evidence);
        $this->assertCount(2, $evidence[0]->highlights);

        $this->assertSame(
            0.62,
            $evidence[0]->highlights[0]['sentiment']
        );

        $this->assertSame(
            -0.31,
            $evidence[0]->highlights[1]['sentiment']
        );
    }
}