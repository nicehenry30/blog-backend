<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class RiskSetting extends Model
{
    protected $fillable = [
        'user_id',
        'risk_per_trade',
        'daily_loss_limit',
        'max_drawdown',
    ];

    protected function casts(): array
    {
        return [
            'risk_per_trade' => 'float',
            'daily_loss_limit' => 'float',
            'max_drawdown' => 'float',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}