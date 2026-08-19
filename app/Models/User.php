<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Foundation\Auth\User as Authenticatable;

use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use App\Services\SubscriptionService;


class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
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
        return $this->hasMany(
            GuardianConnectionCode::class
        );
    }

    public function riskSetting(): HasOne
    {
        return $this->hasOne(RiskSetting::class);
    }
    /**
 * User subscriptions.
 */
    public function subscriptions(): HasMany
    {
        return $this->hasOne(Subscription::class)
        ->where('status', 'active')
        ->where('expires_at', '>', now())
        ->latestOfMany();
    }

    /**
     * User payments.
     */
    public function payments(): HasMany
    {
        return $this->hasMany(Payment::class);
    }
    
    /**
     * Check if the user has an active subscription.
     */
    public function hasActiveSubscription(): bool
    {
          return $this->activeSubscription()->exists();
    }

    /**
     * Check if the user has access to a feature.
     */
    public function hasFeature(string $feature): bool
    {
        return app(SubscriptionService::class)
            ->hasFeature($this, $feature);
    }

    /**
    * User settings.
    */
    public function settings(): HasOne
    {
        return $this->hasOne(UserSetting::class);
    }
}