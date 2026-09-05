<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Referral extends Model
{
    protected $fillable = [
        'referrer_id',
        'referred_user_id',
        'referral_code',
        'qualifying_payment_id',
        'reward_amount',
        'reward_currency',
        'status',
        'qualified_at',
        'rewarded_at',
    ];

    protected $casts = [
        'reward_amount' => 'decimal:2',
        'qualified_at' => 'datetime',
        'rewarded_at' => 'datetime',
    ];

    /**
     * User who referred this user.
     */
    public function referrer(): BelongsTo
    {
        return $this->belongsTo(
            User::class,
            'referrer_id'
        );
    }

    /**
     * User who was referred.
     */
    public function referredUser(): BelongsTo
    {
        return $this->belongsTo(
            User::class,
            'referred_user_id'
        );
    }

    /**
     * Payment that qualified this referral.
     */
    public function qualifyingPayment(): BelongsTo
    {
        return $this->belongsTo(
            Payment::class,
            'qualifying_payment_id'
        );
    }
}