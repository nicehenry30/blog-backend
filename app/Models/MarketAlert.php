<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MarketAlert extends Model
{
    protected $fillable = [
        'title',
        'symbol',
        'impact',
        'alert_time',
        'recommendation',
        'is_active',
    ];

    protected $casts = [
        'alert_time' => 'datetime',
        'is_active' => 'boolean',
    ];

    /**
     * Get the current status of the alert.
     */
    public function getStatusAttribute(): string
    {
        if (! $this->is_active) {
            return 'inactive';
        }

        if ($this->alert_time->isFuture()) {
            return 'upcoming';
        }

        return 'live';
    }
}