<?php

namespace App\Services;

use App\Models\Plan;
use App\Models\Subscription;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use RuntimeException;

class TrialService
{
    /**
     * Start a 7-day trial for a user.
     *
     * The user must have a verified payment method.
     */
    public function startTrial(
        User $user,
        Plan $plan,
        string $paymentProvider,
        string $paymentMethodId,
    ): Subscription {
        return DB::transaction(function () use (
            $user,
            $plan,
            $paymentProvider,
            $paymentMethodId,
        ) {
            // A user can only receive one trial.
            $previousTrial = $user->subscriptions()
                ->where('is_trial', true)
                ->exists();

            if ($previousTrial) {
                throw new RuntimeException(
                    'This user has already used their free trial.'
                );
            }

            // Do not allow another trial while an active
            // subscription already exists.
            $activeSubscription = $user->subscriptions()
                ->where('status', 'active')
                ->exists();

            if ($activeSubscription) {
                throw new RuntimeException(
                    'The user already has an active subscription.'
                );
            }

            $startsAt = Carbon::now();
            $trialEndsAt = $startsAt->copy()->addDays(7);

            return $user->subscriptions()->create([
                'plan_id' => $plan->id,
                'status' => 'active',

                'starts_at' => $startsAt,
                'expires_at' => $trialEndsAt,

                'cancelled_at' => null,

                'auto_renew' => true,

                'is_trial' => true,
                'trial_ends_at' => $trialEndsAt,
                'next_billing_at' => $trialEndsAt,

                'payment_provider' => $paymentProvider,
                'payment_method_id' => $paymentMethodId,
                'payment_method_verified' => true,
            ]);
        });
    }

    /**
     * Check whether a user has already used their trial.
     */
    public function hasUsedTrial(User $user): bool
    {
        return $user->subscriptions()
            ->where('is_trial', true)
            ->exists();
    }

    /**
     * Check whether a user's trial is currently active.
     */
    public function isTrialActive(User $user): bool
    {
        return $user->subscriptions()
            ->where('is_trial', true)
            ->where('status', 'active')
            ->where('trial_ends_at', '>', Carbon::now())
            ->exists();
    }

    /**
     * Get the user's current trial.
     */
    public function currentTrial(User $user): ?Subscription
    {
        return $user->subscriptions()
            ->where('is_trial', true)
            ->where('status', 'active')
            ->where('trial_ends_at', '>', Carbon::now())
            ->latest('id')
            ->first();
    }
}