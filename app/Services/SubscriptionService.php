<?php

namespace App\Services;

use App\Models\Plan;
use App\Models\Signal;
use App\Models\Subscription;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use RuntimeException;

class SubscriptionService
{
    /**
     * Activate a paid subscription for a user.
     */
    public function activateSubscription(
        User $user,
        Plan $plan,
    ): Subscription {
        return DB::transaction(function () use ($user, $plan) {

            if (! $plan->is_active) {
                throw new RuntimeException(
                    'This subscription plan is not active.'
                );
            }

            $activeSubscription = $user->subscriptions()
                ->where('status', 'active')
                ->exists();

            if ($activeSubscription) {
                throw new RuntimeException(
                    'The user already has an active subscription.'
                );
            }

            $startsAt = Carbon::now();

            $expiresAt = match ($plan->billing_cycle) {
                'monthly' => $startsAt->copy()->addMonth(),
                'three_months' => $startsAt->copy()->addMonths(3),
                'yearly' => $startsAt->copy()->addYear(),
                'two_year' => $startsAt->copy()->addYears(2),

                default => throw new RuntimeException(
                    'Invalid billing cycle.'
                ),
            };

            return $user->subscriptions()->create([
                'plan_id' => $plan->id,
                'status' => 'active',

                'starts_at' => $startsAt,
                'expires_at' => $expiresAt,
                'next_billing_at' => $expiresAt,

                'cancelled_at' => null,

                'auto_renew' => true,

               'is_trial' => false,
                'trial_ends_at' => null,

                'payment_provider' => null,
                'payment_method_id' => null,
                'payment_method_verified' => false,
            ]);
        });
    }

    /**
     * Expire an active subscription.
     */
    public function expireSubscription(
        Subscription $subscription,
    ): Subscription {
        if ($subscription->status !== 'active') {
            throw new RuntimeException(
                'Only active subscriptions can be expired.'
            );
        }

        $subscription->update([
            'status' => 'expired',
            'auto_renew' => false,
        ]);

        return $subscription->refresh();
    }

    /**
     * Cancel an active subscription.
     */
    public function cancelSubscription(
        Subscription $subscription,
    ): Subscription {
        if ($subscription->status !== 'active') {
            throw new RuntimeException(
                'Only active subscriptions can be cancelled.'
            );
        }

        $subscription->update([
            'status' => 'cancelled',
            'cancelled_at' => Carbon::now(),
            'auto_renew' => false,
        ]);

        return $subscription->refresh();
    }

    /**
     * Determine whether the user has an active subscription.
     */
    public function hasActiveSubscription(
        User $user
    ): bool {
        return $user->subscriptions()
            ->where('status', 'active')
            ->where(function ($query) {
                $query->whereNull('expires_at')
                    ->orWhere(
                        'expires_at',
                        '>',
                        Carbon::now()
                    );
            })
            ->exists();
    }

    /**
     * Get the user's current active subscription.
     */
    public function currentSubscription(
        User $user,
    ): ?Subscription {
        return $user->subscriptions()
            ->where('status', 'active')
            ->where(function ($query) {
                $query->whereNull('expires_at')
                    ->orWhere(
                        'expires_at',
                        '>',
                        Carbon::now()
                    );
            })
            ->with('plan')
            ->latest('id')
            ->first();
    }

    /**
     * Determine whether a user can view a trading signal.
     *
     * Access is controlled by:
     *
     * 1. Signal visibility
     * 2. User's active subscription
     * 3. Plan feature configuration
     */
    public function canViewSignal(
        User $user,
        Signal $signal,
    ): bool {
        /*
         * Free signals are publicly viewable.
         */
        if ($signal->visibility === Plan::FREE) {
            return true;
        }

        /*
         * Premium and Pro signals require
         * an active subscription.
         */
        $subscription = $this->currentSubscription($user);

        if (! $subscription || ! $subscription->plan) {
            return false;
        }

        /*
         * Let the user's plan determine whether
         * it has permission to view this signal level.
         */
        return $subscription->plan->canViewSignal(
            $signal->visibility
        );
    }

    /**
     * Activate an existing pending subscription.
     */
    public function activatePendingSubscription(
        Subscription $subscription,
    ): Subscription {
        if ($subscription->status !== 'pending') {
            throw new RuntimeException(
                'Only pending subscriptions can be activated.'
            );
        }

        $plan = $subscription->plan;

        if (! $plan || ! $plan->is_active) {
            throw new RuntimeException(
                'This subscription plan is not active.'
            );
        }

        $startsAt = Carbon::now();

        $expiresAt = match ($plan->billing_cycle) {
            'monthly' => $startsAt->copy()->addMonth(),
            'three_months' => $startsAt->copy()->addMonths(3),
            'yearly' => $startsAt->copy()->addYear(),
            'two_year' => $startsAt->copy()->addYears(2),

            default => throw new RuntimeException(
                'Invalid billing cycle.'
            ),
        };

        $subscription->update([
            'status' => 'active',
            'starts_at' => $startsAt,
            'expires_at' => $expiresAt,
            'next_billing_at' => $expiresAt,
            'cancelled_at' => null,
            'auto_renew' => true,
        ]);

        return $subscription->fresh();
    }
}