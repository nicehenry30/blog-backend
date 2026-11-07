<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class NewsEvidenceRecord extends Model
{
    protected $table = 'news_evidence';

    protected $fillable = [
        'news_id',
        'symbol',
        'sentiment_score',
        'match_score',
        'highlights',
    ];

    protected $casts = [
        'sentiment_score' => 'float',
        'match_score' => 'float',
        'highlights' => 'array',
    ];

    public function news(): BelongsTo
    {
        return $this->belongsTo(News::class);
    }
}