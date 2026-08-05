<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Trade extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'symbol',
        'direction',
        'entry',
        'exit',
        'result',
        'profit_loss',
        'notes',
    ];

    protected $casts = [
        'entry' => 'float',
        'exit' => 'float',
        'profit_loss' => 'float',
    ];

    /**
     * The user who owns this trade.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}