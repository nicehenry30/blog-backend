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
                'amount' => (int) ($plan->price * 100), // Kobo
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
                    $response['message'] ?? 'Failed to initialize Paystack transaction.'
                );
            }

            return $response;
        });
    }
}