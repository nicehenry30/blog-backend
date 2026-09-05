<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOneThrough;

class Payment extends Model
{
    use HasFactory;

    protected $fillable = [
        'subscription_id',
        'user_id',

        /*
         * Original application price.
         */
        'amount',
        'currency',

        /*
         * Actual gateway amount/currency.
         */
        'gateway_amount',
        'gateway_currency',

        /*
         * Manual crypto payment fields.
         */
        'crypto_network',
        'crypto_address',
        'transaction_hash',
        'submitted_at',
        'reviewed_at',
        'reviewed_by',

        'gateway',
        'reference',
        'transaction_id',
        'status',
        'gateway_response',
        'paid_at',
    ];

    protected $casts = [
        'amount' => 'decimal:2',
        'gateway_amount' => 'decimal:2',
        'gateway_response' => 'array',
        'paid_at' => 'datetime',
        'submitted_at' => 'datetime',
        'reviewed_at' => 'datetime',
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

    /**
     * Plan associated with this payment.
     *
     * Payment
     *     ↓ subscription_id
     * Subscription
     *     ↓ plan_id
     * Plan
     */
    public function plan(): HasOneThrough
    {
        return $this->hasOneThrough(
            Plan::class,
            Subscription::class,
            'id',
            'id',
            'subscription_id',
            'plan_id'
        );
    }

    /**
     * Staff member who reviewed the payment.
     */
    public function reviewer(): BelongsTo
    {
        return $this->belongsTo(
            User::class,
            'reviewed_by'
        );
    }
}