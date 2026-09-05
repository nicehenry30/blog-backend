<?php

namespace App\Services;

use App\Models\Payment;
use App\Models\Referral;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class ReferralService
{
    /**
     * Referral reward percentage.
     *
     * Example:
     * $100 payment = $2 referral reward.
     */
    private const REWARD_PERCENTAGE = 2.0;

    /**
     * Generate a unique referral code for a user.
     */
    public function generateReferralCode(): string
    {
        do {
            $code = strtoupper(Str::random(8));
        } while (
            User::where('referral_code', $code)->exists()
        );

        return $code;
    }

    /**
     * Find a user by referral code.
     */
    public function findReferrer(string $referralCode): ?User
    {
        return User::where(
            'referral_code',
            $referralCode
        )->first();
    }

    /**
     * Create a referral relationship.
     */
    public function createReferral(
        User $referrer,
        User $referredUser
    ): Referral {
        return DB::transaction(function () use (
            $referrer,
            $referredUser
        ) {
            return Referral::create([
                'referrer_id' => $referrer->id,
                'referred_user_id' => $referredUser->id,
                'referral_code' => $referrer->referral_code,
                'reward_amount' => 0,
                'reward_currency' => 'USD',
                'status' => 'pending',
            ]);
        });
    }

    /**
     * Reward a referral when the referred user makes
     * their first successful paid subscription payment.
     *
     * Reward = 2% of the successful payment amount.
     *
     * The qualifying payment ID is stored so that the
     * same payment can never reward the referral twice.
     */
    public function rewardReferralForPayment(
        User $referredUser,
        Payment $payment
    ): ?Referral {
        return DB::transaction(function () use (
            $referredUser,
            $payment
        ) {
            $referral = Referral::where(
                'referred_user_id',
                $referredUser->id
            )
                ->where('status', 'pending')
                ->lockForUpdate()
                ->first();

            if (!$referral) {
                return null;
            }

            /*
             * Safety check:
             * only successful payments can qualify a referral.
             */
            if ($payment->status !== 'successful') {
                return null;
            }

            /*
             * Safety check:
             * a payment must belong to the referred user.
             */
            if ((int) $payment->user_id !== (int) $referredUser->id) {
                return null;
            }

            /*
             * Safety check:
             * this referral must not already be tied
             * to a qualifying payment.
             */
            if ($referral->qualifying_payment_id !== null) {
                return null;
            }

            /*
             * Calculate the 2% reward.
             */
            $rewardAmount = round(
                (float) $payment->amount
                    * (self::REWARD_PERCENTAGE / 100),
                2
            );

            $referral->update([
                'qualifying_payment_id' => $payment->id,
                'reward_amount' => $rewardAmount,
                'reward_currency' => $payment->currency ?? 'USD',
                'status' => 'rewarded',
                'qualified_at' => now(),
                'rewarded_at' => now(),
            ]);

            return $referral->fresh();
        });
    }

    /**
     * Qualify a referral without rewarding it.
     *
     * Kept for compatibility with existing code/tests.
     */
    public function qualifyReferral(
        User $referredUser
    ): ?Referral {
        $referral = Referral::where(
            'referred_user_id',
            $referredUser->id
        )
            ->where('status', 'pending')
            ->first();

        if (!$referral) {
            return null;
        }

        $referral->update([
            'status' => 'qualified',
            'qualified_at' => now(),
        ]);

        return $referral->fresh();
    }

    /**
     * Mark a qualified referral as rewarded.
     *
     * Kept for compatibility with existing code.
     */
    public function rewardReferral(
        Referral $referral,
        float $amount,
        string $currency = 'USD'
    ): Referral {
        $referral->update([
            'reward_amount' => $amount,
            'reward_currency' => $currency,
            'status' => 'rewarded',
            'rewarded_at' => now(),
        ]);

        return $referral->fresh();
    }

    /**
     * Cancel a referral.
     */
    public function cancelReferral(
        Referral $referral
    ): Referral {
        $referral->update([
            'status' => 'cancelled',
        ]);

        return $referral->fresh();
    }

    /**
     * Get all referrals made by a user.
     */
    public function getUserReferrals(
        User $user
    ) {
        return Referral::where(
            'referrer_id',
            $user->id
        )
            ->with('referredUser')
            ->latest()
            ->get();
    }

    /**
     * Get the referral record for a referred user.
     */
    public function getReferralForUser(
        User $user
    ): ?Referral {
        return Referral::where(
            'referred_user_id',
            $user->id
        )->first();
    }
}