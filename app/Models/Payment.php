<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Payment extends Model
{
    use HasFactory;

    protected $fillable = [
        'subscription_id',
        'user_id',
        'amount',
        'currency',
        'gateway',
        'reference',
        'transaction_id',
        'status',
        'gateway_response',
        'paid_at',
    ];

    protected $casts = [
        'amount' => 'decimal:2',
        'gateway_response' => 'array',
        'paid_at' => 'datetime',
    ];

    /**
     * User that made the payment.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Subscription associated with this payment.
     */
    public function subscription(): BelongsTo
    {
        return $this->belongsTo(Subscription::class);
    }
}