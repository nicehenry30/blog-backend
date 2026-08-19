<?php

namespace App\Services;

use App\Models\PlanFeature;
use App\Models\Signal;
use App\Models\Subscription;
use App\Models\User;

class SubscriptionService
{
    /**
     * Get the active subscription.
     */
    public function getActiveSubscription(User $user): ?Subscription
    {
        return $user->subscriptions()
            ->with('plan.features')
            ->where('status', 'active')
            ->where(function ($query) {
                $query->whereNull('expires_at')
                    ->orWhere('expires_at', '>', now());
            })
            ->latest()
            ->first();
    }

    /**
     * Does the user have an active subscription?
     */
    public function hasActiveSubscription(User $user): bool
    {
        return $this->getActiveSubscription($user) !== null;
    }

    /**
     * Check if a feature is enabled.
     */
    public function hasFeature(
        User $user,
        string $feature
    ): bool {

        $subscription = $this->getActiveSubscription($user);

        if (!$subscription) {
            return false;
        }

        return $subscription
            ->plan
            ->hasFeature($feature);
    }

    /**
     * Get the configured value of a feature.
     */
    public function featureValue(
        User $user,
        string $feature
    ): ?string {

        $subscription = $this->getActiveSubscription($user);

        if (!$subscription) {
            return null;
        }

        return $subscription
            ->plan
            ->featureValue($feature);
    }

    /**
     * Daily signal limit.
     */
    public function dailySignalLimit(User $user): ?string
    {
        return $this->featureValue(
            $user,
            PlanFeature::DAILY_SIGNAL_LIMIT
        );
    }

    /**
     * Guardian account limit.
     */
    public function guardianAccountLimit(User $user): ?string
    {
        return $this->featureValue(
            $user,
            PlanFeature::GUARDIAN_ACCOUNTS
        );
    }

    /**
     * Can the user view this signal?
     */
    public function canViewSignal(
        User $user,
        Signal $signal
    ): bool {

        $subscription = $this->getActiveSubscription($user);

        if (!$subscription) {
            return $signal->visibility === 'free';
        }

        return $subscription
            ->plan
            ->canViewSignal(
                $signal->visibility
            );
    }
}