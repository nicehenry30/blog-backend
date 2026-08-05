<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\UpdateSubscriptionRequest;
use App\Models\Plan;
use App\Models\Subscription;

class SubscriptionController extends Controller
{
    /**
     * Display all subscriptions.
     */
    public function index()
    {
        $subscriptions = Subscription::with([
            'user',
            'plan',
        ])
        ->latest()
        ->paginate(20);

        return view(
            'admin.subscriptions.index',
            compact('subscriptions')
        );
    }

    /**
     * Display a subscription.
     */
    public function show(
        Subscription $subscription
    ) {
        $subscription->load([
            'user',
            'plan',
            'payments',
        ]);

        return view(
            'admin.subscriptions.show',
            compact('subscription')
        );
    }

    /**
     * Show the edit form.
     */
    public function edit(
        Subscription $subscription
    ) {
        $plans = Plan::orderBy('sort_order')->get();

        return view(
            'admin.subscriptions.edit',
            compact(
                'subscription',
                'plans'
            )
        );
    }

    /**
     * Update a subscription.
     */
    public function update(
        UpdateSubscriptionRequest $request,
        Subscription $subscription
    ) {
        $subscription->update(
            $request->validated()
        );

        return redirect()
            ->route('admin.subscriptions.index')
            ->with(
                'success',
                'Subscription updated successfully.'
            );
    }

    /**
     * Cancel a subscription.
     */
    public function destroy(
        Subscription $subscription
    ) {
        $subscription->update([
            'status' => 'cancelled',
            'cancelled_at' => now(),
        ]);

        return redirect()
            ->route('admin.subscriptions.index')
            ->with(
                'success',
                'Subscription cancelled successfully.'
            );
    }
}