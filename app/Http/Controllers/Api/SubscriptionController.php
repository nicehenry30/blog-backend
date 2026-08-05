<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\PlanResource;
use App\Models\Plan;
use App\Models\Subscription;
use Illuminate\Http\Request;

class SubscriptionController extends Controller
{
    /**
     * Get the authenticated user's current subscription.
     */
    public function current(Request $request)
    {
        $subscription = $request->user()
            ->subscriptions()
            ->with('plan.features')
            ->latest()
            ->first();

        if (!$subscription) {
            return response()->json([
                'message' => 'No active subscription found.',
            ], 404);
        }

        return response()->json([
            'subscription' => [
                'id' => $subscription->id,
                'status' => $subscription->status,
                'starts_at' => $subscription->starts_at,
                'expires_at' => $subscription->expires_at,
                'auto_renew' => $subscription->auto_renew,
                'plan' => new PlanResource(
                    $subscription->plan
                ),
            ],
        ]);
    }

    /**
     * Subscribe the authenticated user to a plan.
     * (Payment integration comes later.)
     */
    public function subscribe(
        Request $request
    ) {
        $validated = $request->validate([
            'plan_id' => [
                'required',
                'exists:plans,id',
            ],
        ]);

        $plan = Plan::findOrFail(
            $validated['plan_id']
        );

        $subscription = Subscription::create([
            'user_id' => $request->user()->id,
            'plan_id' => $plan->id,
            'status' => 'active',
            'starts_at' => now(),
            'expires_at' => now()->addMonth(),
            'auto_renew' => true,
        ]);

        return response()->json([
            'message' => 'Subscription created successfully.',
            'subscription' => $subscription->load('plan'),
        ], 201);
    }
}