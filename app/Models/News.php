<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class News extends Model
{
    protected $fillable = [
        'marketaux_uuid',
        'title',
        'description',
        'url',
        'source',
        'published_at',
        'image_url',
        'symbols',
        'currencies',
        'entities',
        'sentiment',
        'sentiment_score',
        'raw_data',
    ];

    protected $casts = [
        'published_at' => 'datetime',
        'symbols' => 'array',
        'currencies' => 'array',
        'entities' => 'array',
        'raw_data' => 'array',
        'sentiment_score' => 'float',
    ];

    public function evidence(): HasMany
    {
        return $this->hasMany(NewsEvidenceRecord::class);
    }
}