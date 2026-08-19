<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class GuardianTradeExecution extends Model
{
    protected $fillable = [
        'guardian_account_id',
        'signal_id',
        'ticket',
        'platform',
        'symbol',
        'direction',
        'lots',
        'entry_price',
        'stop_loss',
        'take_profit',
        'status',
        'reason',
        'error_code',
        'executed_at',
    ];

    protected $casts = [
        'lots' => 'decimal:2',
        'entry_price' => 'decimal:8',
        'stop_loss' => 'decimal:8',
        'take_profit' => 'decimal:8',
        'executed_at' => 'datetime',
    ];

    public function guardianAccount(): BelongsTo
    {
        return $this->belongsTo(
            GuardianAccount::class
        );
    }

    public function signal(): BelongsTo
    {
        return $this->belongsTo(
            Signal::class
        );
    }
}