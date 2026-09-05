<?php

namespace App\Services;

use App\Models\Payment;
use App\Models\Plan;
use App\Models\Subscription;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use RuntimeException;


class PaymentService
{
    public function __construct(
        protected PaystackService $paystackService,
        protected ReferralService $referralService,
        protected ExchangeRateService $exchangeRateService,
    ) {
    }

    /**
     * Initialize a Paystack payment for a subscription plan.
     */
    public function initialize(
        User $user,
        int $planId
    ): array {
        return DB::transaction(function () use ($user, $planId) {

            /*
             * ---------------------------------------------------------------
             * 1. Get the selected active plan.
             * ---------------------------------------------------------------
             */
            $plan = Plan::query()
                ->where('id', $planId)
                ->where('is_active', true)
                ->first();

            if (! $plan) {
                throw new RuntimeException(
                    'The selected plan is not available.'
                );
            }

            /*
             * ---------------------------------------------------------------
             * 2. Check current active subscription.
             * ---------------------------------------------------------------
             */
            $currentSubscription = Subscription::query()
                ->where('user_id', $user->id)
                ->where('status', 'active')
                ->with('plan')
                ->latest('id')
                ->first();

            $isUpgrade = false;

            if ($currentSubscription) {
                $currentPrice = (float) $currentSubscription->plan->price;
                $newPrice = (float) $plan->price;

                /*
                 * Only higher-priced plans are allowed.
                 */
                if ($newPrice <= $currentPrice) {
                    throw new RuntimeException(
                        'You can only upgrade to a higher-priced plan.'
                    );
                }

                $isUpgrade = true;
            }

            /*
             * ---------------------------------------------------------------
             * 3. Create pending subscription.
             * ---------------------------------------------------------------
             */
            $subscription = Subscription::create([
                'user_id' => $user->id,
                'plan_id' => $plan->id,
                'status' => 'pending',
                'starts_at' => null,
                'expires_at' => null,
                'next_billing_at' => null,
                'auto_renew' => true,
                'is_trial' => false,
                'payment_provider' => 'paystack',
            ]);

            /*
             * ---------------------------------------------------------------
             * 4. Generate payment reference.
             * ---------------------------------------------------------------
             */
            $reference = $this->generateReference();

            /*
             * ---------------------------------------------------------------
             * 5. Application amount/currency.
             * ---------------------------------------------------------------
             */
            $applicationAmount = round(
                (float) $plan->price,
                2
            );

            $applicationCurrency = strtoupper(
                $plan->currency ?: 'USD'
            );

            /*
             * ---------------------------------------------------------------
             * 6. Resolve Paystack gateway currency.
             * ---------------------------------------------------------------
             *
             * Tradewisser plans are priced in USD.
             * Paystack merchant currency is configured in .env.
             */
            $gatewayCurrency = $this->resolveGatewayCurrency(
                $applicationCurrency
            );

            /*
             * ---------------------------------------------------------------
             * 7. Convert application amount to gateway currency.
             * ---------------------------------------------------------------
             */
            $gatewayAmount = $this->resolveGatewayAmount(
                $applicationAmount,
                $applicationCurrency,
                $gatewayCurrency
            );

            /*
             * ---------------------------------------------------------------
             * 8. Create local payment record.
             * ---------------------------------------------------------------
             */
            $payment = $this->createPayment(
                $user,
                $subscription,
                $applicationAmount,
                $applicationCurrency,
                'paystack',
                $reference,
                $gatewayAmount,
                $gatewayCurrency
            );

            /*
             * ---------------------------------------------------------------
             * 9. Convert gateway amount to smallest currency unit.
             * ---------------------------------------------------------------
             *
             * NGN:
             * ₦29,985 -> 2,998,500 kobo
             *
             * USD:
             * $19.99 -> 1999 cents
             */
            $paystackAmount = (int) round(
                $gatewayAmount * 100
            );

            /*
             * ---------------------------------------------------------------
             * 10. Callback URL.
             * ---------------------------------------------------------------
             */
            $frontendUrl = rtrim(
                config('app.frontend_url'),
                '/'
            );

            $callbackUrl = $frontendUrl
                . '/payment/callback';

            /*
             * ---------------------------------------------------------------
             * 11. Initialize Paystack transaction.
             * ---------------------------------------------------------------
             */
            $paystackResponse = $this->paystackService
                ->initialize([
                    'email' => $user->email,

                    'amount' => $paystackAmount,

                    'currency' => $gatewayCurrency,

                    'reference' => $reference,

                    'callback_url' => $callbackUrl,

                    'metadata' => [
                        'user_id' => $user->id,
                        'subscription_id' => $subscription->id,
                        'payment_id' => $payment->id,
                        'plan_id' => $plan->id,
                        'is_upgrade' => $isUpgrade,
                    ],
                ]);

            /*
             * ---------------------------------------------------------------
             * 12. Make sure Paystack initialization succeeded.
             * ---------------------------------------------------------------
             */
            if (
                ! isset($paystackResponse['status']) ||
                $paystackResponse['status'] !== true
            ) {
                $payment->delete();
                $subscription->delete();

                throw new RuntimeException(
                    $paystackResponse['message']
                    ?? 'Unable to initialize payment.'
                );
            }

            /*
             * ---------------------------------------------------------------
             * 13. Return data required by Flutter.
             * ---------------------------------------------------------------
             */
            return [
                'payment' => $payment->fresh(),

                'subscription' => $subscription
                    ->fresh()
                    ->load('plan'),

                'authorization_url' =>
                    $paystackResponse['data']['authorization_url']
                    ?? null,

                'access_code' =>
                    $paystackResponse['data']['access_code']
                    ?? null,

                'reference' =>
                    $paystackResponse['data']['reference']
                    ?? $reference,

                'is_upgrade' => $isUpgrade,
            ];
        });
    }

    /**
     * Create a local payment record.
     */
    public function createPayment(
        User $user,
        Subscription $subscription,
        float $amount,
        string $currency,
        string $gateway,
        string $reference,
        ?float $gatewayAmount = null,
        ?string $gatewayCurrency = null
    ): Payment {
        return Payment::create([
            'subscription_id' => $subscription->id,
            'user_id' => $user->id,

            'amount' => $amount,
            'currency' => strtoupper($currency),

            'gateway_amount' => $gatewayAmount,

            'gateway_currency' => $gatewayCurrency
                ? strtoupper($gatewayCurrency)
                : null,

            'gateway' => $gateway,
            'reference' => $reference,

            'transaction_id' => null,
            'status' => 'pending',

            'gateway_response' => null,
            'paid_at' => null,
        ]);
    }

    /**
     * Mark a payment successful.
     */
    public function markSuccessful(
        Payment $payment,
        string $transactionId,
        array $gatewayResponse = []
    ): Payment {
        if ($payment->status === 'failed') {
            throw new RuntimeException(
                'A failed payment cannot be marked successful.'
            );
        }

        if ($payment->status === 'refunded') {
            throw new RuntimeException(
                'A refunded payment cannot be marked successful.'
            );
        }

        $payment->update([
            'status' => 'successful',
            'transaction_id' => $transactionId,

            'gateway_response' => ! empty($gatewayResponse)
                ? $gatewayResponse
                : $payment->gateway_response,

            'paid_at' => now(),
        ]);

        return $payment->fresh();
    }

    /**
     * Mark a payment failed.
     */
    public function markFailed(
        Payment $payment
    ): Payment {
        if ($payment->status === 'successful') {
            throw new RuntimeException(
                'A successful payment cannot be marked failed.'
            );
        }

        if ($payment->status === 'refunded') {
            throw new RuntimeException(
                'A refunded payment cannot be marked failed.'
            );
        }

        $payment->update([
            'status' => 'failed',
        ]);

        return $payment->fresh();
    }

    /**
     * Check whether a payment is pending.
     */
    public function isPending(
        Payment $payment
    ): bool {
        return $payment->status === 'pending';
    }

    /**
     * Complete a verified payment and activate its subscription.
     *
     * This operation is idempotent.
     */
    public function completePayment(
        Payment $payment,
        string $transactionId,
        array $gatewayResponse = []
    ): Payment {
        return DB::transaction(function () use (
            $payment,
            $transactionId,
            $gatewayResponse
        ) {
            $payment = Payment::query()
                ->whereKey($payment->id)
                ->lockForUpdate()
                ->firstOrFail();

            /*
             * Already completed.
             */
            if ($payment->status === 'successful') {
                return $payment->fresh([
                    'subscription.plan',
                ]);
            }

            if ($payment->status !== 'pending') {
                throw new RuntimeException(
                    'Only pending payments can be completed.'
                );
            }

            /*
             * Mark payment successful.
             */
            $payment->update([
                'status' => 'successful',
                'transaction_id' => $transactionId,

                'gateway_response' => ! empty($gatewayResponse)
                    ? $gatewayResponse
                    : $payment->gateway_response,

                'paid_at' => now(),
            ]);

            /*
             * Lock subscription.
             */
            $subscription = Subscription::query()
                ->whereKey($payment->subscription_id)
                ->lockForUpdate()
                ->firstOrFail();

            $subscription->load('plan');

            /*
             * Find old active subscriptions.
             */
            $oldSubscriptions = Subscription::query()
                ->where('user_id', $payment->user_id)
                ->where('status', 'active')
                ->where('id', '!=', $subscription->id)
                ->lockForUpdate()
                ->get();

            /*
             * Cancel old subscription(s).
             */
            foreach ($oldSubscriptions as $oldSubscription) {
                $oldSubscription->update([
                    'status' => 'cancelled',
                    'cancelled_at' => now(),
                    'auto_renew' => false,
                ]);
            }

            /*
             * Activate new subscription.
             */
            $startsAt = now();

            $expiresAt = match (
                $subscription->plan->billing_cycle
            ) {
                'yearly', 'annual' =>
                    $startsAt->copy()->addYear(),

                'weekly' =>
                    $startsAt->copy()->addWeek(),

                'three_months' =>
                    $startsAt->copy()->addMonths(3),

                'two_year' =>
                    $startsAt->copy()->addYears(2),

                default =>
                    $startsAt->copy()->addMonth(),
            };

           $subscription->update([
            'status' => 'active',
            'starts_at' => $startsAt,
            'expires_at' => $expiresAt,
            'next_billing_at' => $expiresAt,

            /*
            * Manual crypto payments cannot be
            * automatically renewed.
            */
            'auto_renew' =>
                $subscription->payment_provider !== 'crypto',
            ]);
            /*
             * Reward referral if applicable.
             */
            $user = User::find($payment->user_id);

            if ($user) {
                $this->referralService
                    ->rewardReferralForPayment(
                        $user,
                        $payment->fresh()
                    );
            }

            return $payment->fresh([
                'subscription.plan',
            ]);
        });
    }

    /**
     * Generate a unique payment reference.
     */
    protected function generateReference(): string
    {
        do {
            $reference = 'TW-' . strtoupper(
                Str::random(20)
            );
        } while (
            Payment::where(
                'reference',
                $reference
            )->exists()
        );

        return $reference;
    }

    /**
     * Resolve the gateway currency.
     */
    protected function resolveGatewayCurrency(
        string $applicationCurrency
    ): string {
        $merchantCurrency = strtoupper(
            config(
                'services.paystack.merchant_currency',
                'NGN'
            )
        );

        if ($merchantCurrency === '') {
            throw new RuntimeException(
                'Paystack merchant currency is not configured.'
            );
        }

        return $merchantCurrency;
    }

    /**
     * Resolve gateway amount in major currency units.
     */
    protected function resolveGatewayAmount(
        float $applicationAmount,
        string $applicationCurrency,
        string $gatewayCurrency
    ): float {
        $applicationCurrency =
            strtoupper($applicationCurrency);

        $gatewayCurrency =
            strtoupper($gatewayCurrency);

        /*
         * Same currency: no conversion required.
         */
        if ($applicationCurrency === $gatewayCurrency) {
            return round(
                $applicationAmount,
                2
            );
        }

        /*
         * Existing Tradewisser conversion system:
         *
         * USD -> NGN
         */
        if (
            $applicationCurrency === 'USD' &&
            $gatewayCurrency === 'NGN'
        ) {
            return $this->exchangeRateService
                ->convertFromUsd(
                    $applicationAmount,
                    'NGN'
                );
        }

        throw new RuntimeException(
            "Currency conversion from {$applicationCurrency} "
            . "to {$gatewayCurrency} is not configured."
        );
    }

            /**
     * Initialize a manual USDT crypto payment.
     *
     * USDT is treated as USD for payment purposes:
     *
     * $1.00 USD = 1.00 USDT
     *
     * The payment remains pending until an admin manually
     * verifies and approves the blockchain transaction.
     */
    public function initializeCrypto(
        User $user,
        int $planId
    ): array {
        return DB::transaction(function () use (
            $user,
            $planId
        ) {

            /*
            * ---------------------------------------------------------------
            * 1. Get the selected active plan.
            * ---------------------------------------------------------------
            */
            $plan = Plan::query()
                ->where('id', $planId)
                ->where('is_active', true)
                ->first();

            if (! $plan) {
                throw new RuntimeException(
                    'The selected plan is not available.'
                );
            }

            /*
            * ---------------------------------------------------------------
            * 2. Check current active subscription.
            * ---------------------------------------------------------------
            */
            $currentSubscription = Subscription::query()
                ->where('user_id', $user->id)
                ->where('status', 'active')
                ->with('plan')
                ->latest('id')
                ->first();

            $isUpgrade = false;

            if ($currentSubscription) {

                $currentPrice =
                    (float) $currentSubscription->plan->price;

                $newPrice =
                    (float) $plan->price;

                /*
                * Only higher-priced plans are allowed.
                */
                if ($newPrice <= $currentPrice) {
                    throw new RuntimeException(
                        'You can only upgrade to a higher-priced plan.'
                    );
                }

                $isUpgrade = true;
            }

            /*
            * ---------------------------------------------------------------
            * 3. Create pending subscription.
            * ---------------------------------------------------------------
            */
            $subscription = Subscription::create([
                'user_id' => $user->id,
                'plan_id' => $plan->id,

                'status' => 'pending',

                'starts_at' => null,
                'expires_at' => null,
                'next_billing_at' => null,

                'auto_renew' => false,

                'is_trial' => false,
                'trial_ends_at' => null,

                'payment_provider' => 'crypto',

                'payment_method_id' => 'USDT-TRC20',

                'payment_method_verified' => false,

                'payment_method_reference' => null,
            ]);

            /*
            * ---------------------------------------------------------------
            * 4. Generate unique local payment reference.
            * ---------------------------------------------------------------
            */
            $reference = $this->generateReference();

            /*
            * ---------------------------------------------------------------
            * 5. Application price.
            *
            * Plans are priced in USD.
            *
            * For manual USDT:
            *
            * 1 USD = 1 USDT
            * ---------------------------------------------------------------
            */
            $applicationAmount = round(
                (float) $plan->price,
                2
            );

            /*
            * ---------------------------------------------------------------
            * 6. Create pending crypto payment.
            * ---------------------------------------------------------------
            */
            $payment = Payment::create([
                'subscription_id' => $subscription->id,
                'user_id' => $user->id,

                'amount' => $applicationAmount,
                'currency' => 'USD',

                'gateway_amount' => $applicationAmount,
                'gateway_currency' => 'USDT',

                'crypto_network' =>
                    config('services.crypto.network'),

                'crypto_address' =>
                    config('services.crypto.wallet_address'),

                'transaction_hash' => null,

                'submitted_at' => null,
                'reviewed_at' => null,
                'reviewed_by' => null,

                'gateway' => 'crypto',

                'reference' => $reference,

                'transaction_id' => null,

                'status' => 'pending',

                'gateway_response' => null,

                'paid_at' => null,
            ]);

            /*
            * ---------------------------------------------------------------
            * 7. Return payment instructions to Flutter.
            * ---------------------------------------------------------------
            */
            return [
                'payment' => $payment->fresh(),

                'subscription' => $subscription
                    ->fresh()
                    ->load('plan'),

                'payment_method' => 'USDT',

                'network' =>
                    config('services.crypto.network'),

                'wallet_address' =>
                    config('services.crypto.wallet_address'),

                'amount_usdt' =>
                    $applicationAmount,

                'reference' => $reference,

                'is_upgrade' => $isUpgrade,
            ];
        });
    }

        /**
     * Submit a transaction hash for a manual crypto payment.
     *
     * The payment remains pending until an admin
     * manually verifies and approves it.
     */
    public function submitCryptoTransaction(
        User $user,
        int $paymentId,
        string $transactionHash
    ): Payment {
        return DB::transaction(function () use (
            $user,
            $paymentId,
            $transactionHash
        ) {
            $payment = Payment::query()
                ->whereKey($paymentId)
                ->where('user_id', $user->id)
                ->lockForUpdate()
                ->first();

            if (! $payment) {
                throw new RuntimeException(
                    'Payment not found.'
                );
            }

            if ($payment->gateway !== 'crypto') {
                throw new RuntimeException(
                    'This is not a crypto payment.'
                );
            }

            if ($payment->status !== 'pending') {
                throw new RuntimeException(
                    'Only pending crypto payments can be submitted.'
                );
            }

            if ($payment->transaction_hash) {
                throw new RuntimeException(
                    'A transaction hash has already been submitted for this payment.'
                );
            }

            $transactionHash = trim($transactionHash);

            if ($transactionHash === '') {
                throw new RuntimeException(
                    'Transaction hash cannot be empty.'
                );
            }

            $payment->update([
                'transaction_hash' => $transactionHash,
                'submitted_at' => now(),
            ]);

            return $payment->fresh();
        });
    }   
    
        /**
     * Approve a submitted manual crypto payment.
     *
     * The payment must have a submitted transaction hash.
     * Approval activates the subscription through completePayment().
     */
    public function approveCryptoPayment(
        Payment $payment,
        User $admin
    ): Payment {
        return DB::transaction(function () use ($payment, $admin) {

            $payment = Payment::query()
                ->whereKey($payment->id)
                ->lockForUpdate()
                ->firstOrFail();

            if ($payment->gateway !== 'crypto') {
                throw new RuntimeException(
                    'This is not a crypto payment.'
                );
            }

            if ($payment->status !== 'pending') {
                throw new RuntimeException(
                    'Only pending crypto payments can be approved.'
                );
            }

            if (! $payment->transaction_hash) {
                throw new RuntimeException(
                    'This payment does not have a submitted transaction hash.'
                );
            }

            /*
            * Record the admin review.
            */
            $payment->update([
                'reviewed_at' => now(),
                'reviewed_by' => $admin->id,
            ]);

            /*
            * Complete the payment using the existing
            * centralized payment completion workflow.
            */
            return $this->completePayment(
                $payment,
                $payment->transaction_hash,
                [
                    'payment_type' => 'manual_crypto',
                    'network' => $payment->crypto_network,
                    'reviewed_by' => $admin->id,
                    'reviewed_at' => now()->toDateTimeString(),
                ]
            );
        });
    }

    /**
     * Reject a submitted manual crypto payment.
     */
    public function rejectCryptoPayment(
        Payment $payment,
        User $admin
    ): Payment {
        return DB::transaction(function () use ($payment, $admin) {

            $payment = Payment::query()
                ->whereKey($payment->id)
                ->lockForUpdate()
                ->firstOrFail();

            if ($payment->gateway !== 'crypto') {
                throw new RuntimeException(
                    'This is not a crypto payment.'
                );
            }

            if ($payment->status !== 'pending') {
                throw new RuntimeException(
                    'Only pending crypto payments can be rejected.'
                );
            }

            $payment->update([
                'status' => 'failed',
                'reviewed_at' => now(),
                'reviewed_by' => $admin->id,
            ]);

            return $payment->fresh([
                'subscription.plan',
            ]);
        });
    }
}