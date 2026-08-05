<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class GuardianAccount extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'platform',
        'account_number',
        'broker',
        'device_token_hash',
        'is_connected',
        'is_enabled',
        'balance',
        'equity',
        'current_drawdown',
        'open_positions',
        'daily_profit_loss',
        'last_seen_at',
    ];

    protected $casts = [
        'is_connected' => 'boolean',
        'is_enabled' => 'boolean',
        'balance' => 'float',
        'equity' => 'float',
        'current_drawdown' => 'float',
        'open_positions' => 'integer',
        'daily_profit_loss' => 'float',
        'last_seen_at' => 'datetime',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}