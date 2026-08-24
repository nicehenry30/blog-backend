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
    protected PaystackService $paystackService;

    protected SubscriptionService $subscriptionService;

    protected ExchangeRateService $exchangeRateService;

    public function __construct(
        PaystackService $paystackService,
        SubscriptionService $subscriptionService,
        ExchangeRateService $exchangeRateService
    ) {
        $this->paystackService = $paystackService;
        $this->subscriptionService = $subscriptionService;
        $this->exchangeRateService = $exchangeRateService;
    }

    /**
     * Initialize a Paystack payment for a subscription plan.
     *
     * Supports:
     *
     * - Free user -> paid plan
     * - No subscription -> paid plan
     * - Active plan -> higher priced plan (upgrade)
     *
     * Does NOT allow:
     *
     * - Same plan purchase
     * - Downgrade
     */
    public function initialize(
        User $user,
        int $planId
    ): array {
        return DB::transaction(function () use ($user, $planId) {

            /*
             * Find selected plan.
             */
            $plan = Plan::find($planId);

            if (! $plan) {
                throw new RuntimeException(
                    'Subscription plan not found.'
                );
            }

            /*
             * Only active plans can be purchased.
             */
            if (! $plan->is_active) {
                throw new RuntimeException(
                    'This subscription plan is not active.'
                );
            }

            /*
             * Plans must be priced in USD.
             */
            $planCurrency = strtoupper(
                $plan->currency
            );

            if ($planCurrency !== 'USD') {
                throw new RuntimeException(
                    'Subscription plans must be priced in USD.'
                );
            }

            $usdAmount = (float) $plan->price;

            /*
             * Find the user's current active subscription.
             */
            $activeSubscription = $user
                ->subscriptions()
                ->with('plan')
                ->where('status', 'active')
                ->latest()
                ->first();

            /*
             * If the user already has this exact plan,
             * do not create another subscription.
             */
            if ($activeSubscription) {

                $currentPlan = $activeSubscription->plan;

                if (
                    $currentPlan &&
                    (int) $currentPlan->id === (int) $plan->id
                ) {
                    throw new RuntimeException(
                        'You are already subscribed to this plan.'
                    );
                }

                /*
                 * Prevent downgrades.
                 *
                 * We compare the USD prices of the plans.
                 */
                if (
                    $currentPlan &&
                    (float) $plan->price <=
                        (float) $currentPlan->price
                ) {
                    throw new RuntimeException(
                        'You can only upgrade to a higher-priced plan.'
                    );
                }
            }

            /*
             * Paystack merchant currency.
             */
            $gatewayCurrency = strtoupper(
                config(
                    'services.paystack.merchant_currency',
                    'NGN'
                )
            );

            /*
             * Convert the USD plan price using
             * the current exchange rate.
             */
            $gatewayAmount =
                $this->exchangeRateService
                    ->convertFromUsd(
                        $usdAmount,
                        $gatewayCurrency
                    );

            /*
             * Create the NEW pending subscription.
             *
             * IMPORTANT:
             *
             * If this is an upgrade, the existing
             * subscription remains ACTIVE until payment
             * has been successfully verified.
             */
            $subscription = $user->subscriptions()->create([
                'plan_id' => $plan->id,
                'status' => 'pending',

                'starts_at' => null,
                'expires_at' => null,
                'next_billing_at' => null,
                'cancelled_at' => null,

                'auto_renew' => true,

                'is_trial' => false,
                'trial_started_at' => null,
                'trial_ends_at' => null,

                'payment_provider' => 'paystack',
                'payment_method_id' => null,
                'payment_method_verified' => false,
            ]);

            /*
             * Generate unique Tradewisser payment reference.
             */
            $reference =
                'TW-' . strtoupper(
                    Str::random(20)
                );

            /*
             * Create pending payment.
             */
            $payment = $this->createPayment(
                $user,
                $subscription,
                $usdAmount,
                $planCurrency,
                'paystack',
                $reference,
                $gatewayAmount,
                $gatewayCurrency
            );

            /*
             * Paystack expects the amount in the
             * smallest unit of the gateway currency.
             *
             * Example:
             *
             * 26,890.81 NGN
             *
             * becomes:
             *
             * 2,689,081 kobo
             */
            $gatewayAmountInSmallestUnit =
                (int) round(
                    $gatewayAmount * 100
                );

            /*
             * Generate the registered callback URL.
             */
            $callbackUrl = route(
                'payment.callback'
            );

            /*
             * Initialize Paystack transaction.
             */
            $paystackResponse =
                $this->paystackService
                    ->initializeTransaction([
                        'email' => $user->email,

                        'amount' =>
                            $gatewayAmountInSmallestUnit,

                        'currency' =>
                            $gatewayCurrency,

                        'reference' =>
                            $reference,

                        'callback_url' =>
                            $callbackUrl,

                        'metadata' => [
                            'user_id' =>
                                $user->id,

                            'subscription_id' =>
                                $subscription->id,

                            'payment_id' =>
                                $payment->id,

                            'plan_id' =>
                                $plan->id,

                            'plan_name' =>
                                $plan->name,

                            'usd_amount' =>
                                $usdAmount,

                            'gateway_amount' =>
                                $gatewayAmount,

                            'gateway_currency' =>
                                $gatewayCurrency,

                            'is_upgrade' =>
                                $activeSubscription !== null,
                        ],
                    ]);

            if (
                ! isset($paystackResponse['status']) ||
                $paystackResponse['status'] !== true
            ) {
                throw new RuntimeException(
                    $paystackResponse['message']
                    ??
                    'Unable to initialize Paystack payment.'
                );
            }

            return [
                'payment' =>
                    $payment->fresh(),

                'subscription' =>
                    $subscription->fresh(),

                'authorization_url' =>
                    $paystackResponse['data']
                        ['authorization_url']
                    ?? null,

                'access_code' =>
                    $paystackResponse['data']
                        ['access_code']
                    ?? null,

                'reference' =>
                    $paystackResponse['data']
                        ['reference']
                    ?? $reference,

                'is_upgrade' =>
                    $activeSubscription !== null,
            ];
        });
    }

    /**
     * Create a pending payment.
     */
    public function createPayment(
        User $user,
        Subscription $subscription,
        float $amount,
        string $currency,
        string $gateway,
        string $reference,
        float $gatewayAmount,
        string $gatewayCurrency,
    ): Payment {
        return Payment::create([
            'user_id' =>
                $user->id,

            'subscription_id' =>
                $subscription->id,

            /*
             * Original application price.
             */
            'amount' =>
                $amount,

            'currency' =>
                $currency,

            /*
             * Actual amount sent to Paystack.
             */
            'gateway_amount' =>
                $gatewayAmount,

            'gateway_currency' =>
                $gatewayCurrency,

            'gateway' =>
                $gateway,

            'reference' =>
                $reference,

            'status' =>
                'pending',
        ]);
    }

    /**
     * Complete a successfully verified payment.
     *
     * This is the central method responsible for:
     *
     * 1. Activating the NEW subscription.
     * 2. Replacing the OLD active subscription if this
     *    payment is an upgrade.
     * 3. Marking the payment successful.
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

            /*
             * Lock the payment so duplicate callbacks
             * cannot process it simultaneously.
             */
            $payment = Payment::query()
                ->lockForUpdate()
                ->findOrFail($payment->id);

            /*
             * Idempotency.
             */
            if ($payment->status === 'successful') {
                return $payment->fresh();
            }

            if ($payment->status !== 'pending') {
                throw new RuntimeException(
                    'Only pending payments can be completed.'
                );
            }

            /*
             * Get the EXACT subscription attached
             * to this payment.
             */
            $subscription =
                $payment->subscription;

            if (! $subscription) {
                throw new RuntimeException(
                    'Payment subscription not found.'
                );
            }

            /*
             * Find any currently active subscription
             * belonging to this user.
             *
             * This is the OLD subscription when this
             * payment represents an upgrade.
             */
            $oldSubscription =
                Subscription::query()
                    ->where(
                        'user_id',
                        $payment->user_id
                    )
                    ->where(
                        'status',
                        'active'
                    )
                    ->where(
                        'id',
                        '!=',
                        $subscription->id
                    )
                    ->lockForUpdate()
                    ->latest()
                    ->first();

            /*
             * Activate the NEW subscription first.
             */
            $subscription =
                $this->subscriptionService
                    ->activatePendingSubscription(
                        $subscription
                    );

            /*
             * If there was an old active subscription,
             * replace it now that payment has succeeded.
             */
            if ($oldSubscription) {

                $oldSubscription->update([
                    'status' => 'cancelled',
                    'cancelled_at' => now(),
                ]);
            }

            /*
             * Mark payment successful.
             */
            $payment->update([
                'status' =>
                    'successful',

                'transaction_id' =>
                    $transactionId,

                'gateway_response' =>
                    $gatewayResponse,

                'paid_at' =>
                    now(),
            ]);

            return $payment->fresh();
        });
    }

    /**
     * Mark a payment as successful.
     */
    public function markSuccessful(
        Payment $payment,
        string $transactionId,
    ): Payment {
        if ($payment->status === 'successful') {
            return $payment;
        }

        if ($payment->status !== 'pending') {
            throw new RuntimeException(
                'Only pending payments can be marked successful.'
            );
        }

        $payment->update([
            'status' =>
                'successful',

            'transaction_id' =>
                $transactionId,

            'paid_at' =>
                now(),
        ]);

        return $payment->fresh();
    }

    /**
     * Mark a payment as failed.
     */
    public function markFailed(
        Payment $payment
    ): Payment {
        if ($payment->status === 'successful') {
            throw new RuntimeException(
                'A successful payment cannot be marked as failed.'
            );
        }

        if ($payment->status !== 'pending') {
            throw new RuntimeException(
                'Only pending payments can be marked as failed.'
            );
        }

        $payment->update([
            'status' =>
                'failed',
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
}