<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\PlanResource;
use App\Models\Plan;
use App\Services\SubscriptionService;
use Illuminate\Http\Request;
use RuntimeException;

class SubscriptionController extends Controller
{
    public function __construct(
        protected SubscriptionService $subscriptionService
    ) {
    }

    /**
     * Get the authenticated user's current subscription.
     */
    public function current(Request $request)
    {
        $subscription = $this->subscriptionService
            ->currentSubscription($request->user());

        if (! $subscription) {
            return response()->json([
                'message' => 'No active subscription found.',
            ], 404);
        }

        $subscription->load('plan.features');

        return response()->json([
            'subscription' => [
                'id' => $subscription->id,
                'status' => $subscription->status,
                'starts_at' => $subscription->starts_at,
                'expires_at' => $subscription->expires_at,
                'next_billing_at' => $subscription->next_billing_at,
                'auto_renew' => $subscription->auto_renew,
                'is_trial' => $subscription->is_trial,
                'trial_started_at' => $subscription->trial_started_at,
                'trial_ends_at' => $subscription->trial_ends_at,
                'payment_provider' => $subscription->payment_provider,
                'plan' => new PlanResource(
                    $subscription->plan
                ),
            ],
        ]);
    }

    /**
     * Subscribe the authenticated user to a paid plan.
     *
     * Payment integration comes later.
     */
    public function subscribe(Request $request)
    {
        $validated = $request->validate([
            'plan_id' => [
                'required',
                'exists:plans,id',
            ],
        ]);

        $plan = Plan::findOrFail(
            $validated['plan_id']
        );

        try {
            $subscription = $this->subscriptionService
                ->activateSubscription(
                    $request->user(),
                    $plan
                );

            return response()->json([
                'message' => 'Subscription created successfully.',
                'subscription' => $subscription->load('plan'),
            ], 201);

        } catch (RuntimeException $e) {
            return response()->json([
                'message' => $e->getMessage(),
            ], 422);
        }
    }
}