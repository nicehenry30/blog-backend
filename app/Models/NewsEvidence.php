<?php

namespace App\Models;

class NewsEvidence
{
    public function __construct(
        public readonly string $symbol,
        public readonly string $title,
        public readonly string $url,
        public readonly ?string $source,
        public readonly ?string $publishedAt,
        public readonly ?float $sentimentScore,
        public readonly ?float $matchScore,
        public readonly array $highlights = [],
    ) {
    }
}