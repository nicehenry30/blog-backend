<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class UserSetting extends Model
{
    protected $fillable = [
        'user_id',
        'auto_trading_enabled',
        'minimum_signal_quality',
        'minimum_ai_confidence',
        'allow_buy',
        'allow_sell',
        'require_ai_confirmation',
        'require_stop_loss',
        'require_take_profit',
    ];

    protected $casts = [
        'auto_trading_enabled' => 'boolean',
        'minimum_signal_quality' => 'float',
        'minimum_ai_confidence' => 'float',
        'allow_buy' => 'boolean',
        'allow_sell' => 'boolean',
        'require_ai_confirmation' => 'boolean',
        'require_stop_loss' => 'boolean',
        'require_take_profit' => 'boolean',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}