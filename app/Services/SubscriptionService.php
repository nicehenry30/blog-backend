<?php

namespace App\Services;

use App\Models\PlanFeature;
use App\Models\Subscription;
use App\Models\User;

class SubscriptionService
{
    /**
     * Get the user's active subscription.
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
     * Check if the user has a feature.
     */
    public function hasFeature(
        User $user,
        string $feature
    ): bool {

        $subscription = $this->getActiveSubscription($user);

        if (!$subscription) {
            return false;
        }

        return $subscription->plan
            ->features()
            ->where('feature', $feature)
            ->where('enabled', true)
            ->exists();
    }

    /**
     * Check if the user has an active subscription.
     */
    public function hasActiveSubscription(User $user): bool
    {
        return $this->getActiveSubscription($user) !== null;
    }
}