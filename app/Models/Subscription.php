<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Subscription extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'plan_id',
        'status',
        'starts_at',
        'expires_at',
        'next_billing_at',
        'cancelled_at',
        'auto_renew',

        'is_trial',
        'trial_ends_at',

        'payment_provider',
        'payment_method_id',
        'payment_method_verified',
        'payment_method_reference',
    ];

    protected $casts = [
        'starts_at' => 'datetime',
        'expires_at' => 'datetime',
        'next_billing_at' => 'datetime',
        'cancelled_at' => 'datetime',

        'auto_renew' => 'boolean',
        'is_trial' => 'boolean',
        'trial_ends_at' => 'datetime',
        'payment_method_verified' => 'boolean',
    ];

    /**
     * Owner of this subscription.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Subscription plan.
     */
    public function plan(): BelongsTo
    {
        return $this->belongsTo(Plan::class);
    }

    /**
     * Payments made for this subscription.
     */
    public function payments(): HasMany
    {
        return $this->hasMany(Payment::class);
    }
}