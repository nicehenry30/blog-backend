<?php

namespace App\Models;

use App\Services\SubscriptionService;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
        'referral_code',
        'referred_by_user_id',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    public function trades(): HasMany
    {
        return $this->hasMany(Trade::class);
    }

    public function guardianAccounts(): HasMany
    {
        return $this->hasMany(GuardianAccount::class);
    }

    public function guardianConnectionCodes(): HasMany
    {
        return $this->hasMany(GuardianConnectionCode::class);
    }

    public function riskSetting(): HasOne
    {
        return $this->hasOne(RiskSetting::class);
    }

    public function subscriptions(): HasMany
    {
        return $this->hasMany(Subscription::class);
    }

    public function payments(): HasMany
    {
        return $this->hasMany(Payment::class);
    }

    public function hasActiveSubscription(): bool
    {
        return $this->activeSubscription()->exists();
    }

    public function hasFeature(string $feature): bool
    {
        return app(SubscriptionService::class)
            ->hasFeature($this, $feature);
    }

    public function settings(): HasOne
    {
        return $this->hasOne(UserSetting::class);
    }

    /*
    |--------------------------------------------------------------------------
    | Referral Relationships
    |--------------------------------------------------------------------------
    */

    public function referrals(): HasMany
    {
        return $this->hasMany(
            Referral::class,
            'referrer_id'
        );
    }

    public function referredBy(): HasOne
    {
        return $this->hasOne(
            Referral::class,
            'referred_user_id'
        );
    }

    public function referrer(): BelongsTo
    {
        return $this->belongsTo(
            User::class,
            'referred_by_user_id'
        );
    }
}