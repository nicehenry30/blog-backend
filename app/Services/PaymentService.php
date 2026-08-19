<?php

namespace App\Services;

use App\Models\Payment;
use App\Models\Plan;
use App\Models\Subscription;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class PaymentService
{
    public function __construct(
        protected PaystackService $paystackService
    ) {
    }

    /**
     * Initialize a Paystack payment.
     */
    public function initialize(User $user, int $planId): array
    {
        $plan = Plan::findOrFail($planId);

        return DB::transaction(function () use ($user, $plan) {

            /*
            |--------------------------------------------------------------------------
            | Create Pending Subscription
            |--------------------------------------------------------------------------
            */

            $subscription = Subscription::create([
                'user_id' => $user->id,
                'plan_id' => $plan->id,
                'status' => 'pending',
                'starts_at' => null,
                'expires_at' => null,
                'auto_renew' => true,
            ]);

            /*
            |--------------------------------------------------------------------------
            | Generate Unique Payment Reference
            |--------------------------------------------------------------------------
            */

            $reference = 'TW-' . strtoupper(Str::random(16));

            /*
            |--------------------------------------------------------------------------
            | Create Pending Payment
            |--------------------------------------------------------------------------
            */

            $payment = Payment::create([
                'subscription_id' => $subscription->id,
                'user_id' => $user->id,
                'amount' => $plan->price,
                'currency' => $plan->currency,
                'gateway' => 'paystack',
                'reference' => $reference,
                'status' => 'pending',
            ]);

            /*
            |--------------------------------------------------------------------------
            | Initialize Paystack Transaction
            |--------------------------------------------------------------------------
            */

            $response = $this->paystackService->initializeTransaction([
                'email' => $user->email,
                'amount' => (int) ($plan->price * 100),
                'reference' => $reference,
                'callback_url' => url('/payment/callback'),
                'metadata' => [
                    'payment_id' => $payment->id,
                    'subscription_id' => $subscription->id,
                ],
            ]);

            /*
            |--------------------------------------------------------------------------
            | Roll Back Transaction if Paystack Fails
            |--------------------------------------------------------------------------
            */

            if (
                !isset($response['status']) ||
                $response['status'] !== true
            ) {
                throw new \Exception(
                    $response['message']
                        ?? 'Failed to initialize Paystack transaction.'
                );
            }

            return $response;
        });
    }

    /**
     * Complete a successful payment and activate its subscription.
     *
     * This method is shared by payment gateways such as
     * Paystack and future crypto payments.
     */
    public function completePayment(
        Payment $payment,
        string $transactionId,
        array $gatewayResponse = []
    ): void {
        $subscription = $payment->subscription;
        $plan = $subscription->plan;

        $startsAt = now();

        $expiresAt = match ($plan->billing_cycle) {
            'monthly' => $startsAt->copy()->addMonth(),

            'three_months' => $startsAt->copy()->addMonths(3),

            'yearly' => $startsAt->copy()->addYear(),

            'two_year' => $startsAt->copy()->addYears(2),

            default => throw new \Exception(
                'Invalid billing cycle: ' . $plan->billing_cycle
            ),
        };

        $payment->update([
            'status' => 'successful',
            'transaction_id' => $transactionId,
            'gateway_response' => $gatewayResponse,
            'paid_at' => $startsAt,
        ]);

        $subscription->update([
            'status' => 'active',
            'starts_at' => $startsAt,
            'expires_at' => $expiresAt,
        ]);
    }

}