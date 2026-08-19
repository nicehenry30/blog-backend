<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Plan extends Model
{
    use HasFactory;

    /*
    |--------------------------------------------------------------------------
    | Plan Constants
    |--------------------------------------------------------------------------
    */

    public const FREE = 'free';
    public const PREMIUM = 'premium';
    public const PRO = 'pro';

    protected $fillable = [
        'name',
        'slug',
        'description',
        'price',
        'currency',
        'billing_cycle',
        'is_active',
        'sort_order',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'is_active' => 'boolean',
    ];

    /**
     * Plan Features
     */
    public function features(): HasMany
    {
        return $this->hasMany(PlanFeature::class);
    }

    /**
     * Subscriptions
     */
    public function subscriptions(): HasMany
    {
        return $this->hasMany(Subscription::class);
    }

    /**
     * Check whether a feature is enabled.
     */
    public function hasFeature(string $feature): bool
    {
        return $this->features()
            ->where('feature', $feature)
            ->where('enabled', true)
            ->exists();
    }

    /**
     * Get the configured value of a feature.
     */
    public function featureValue(string $feature): ?string
    {
        return $this->features()
            ->where('feature', $feature)
            ->value('value');
    }

    /**
     * Check if the plan can view a signal visibility level.
     */
    public function canViewSignal(string $visibility): bool
    {
        return match ($visibility) {

            self::FREE =>
                $this->hasFeature(PlanFeature::VIEW_FREE_SIGNALS),

            self::PREMIUM =>
                $this->hasFeature(PlanFeature::VIEW_PREMIUM_SIGNALS),

            self::PRO =>
                $this->hasFeature(PlanFeature::VIEW_PRO_SIGNALS),

            default => false,
        };
    }

    /**
     * Daily signal limit.
     */
    public function dailySignalLimit(): ?string
    {
        return $this->featureValue(
            PlanFeature::DAILY_SIGNAL_LIMIT
        );
    }

    /**
     * Guardian account limit.
     */
    public function guardianAccounts(): ?string
    {
        return $this->featureValue(
            PlanFeature::GUARDIAN_ACCOUNTS
        );
    }
}