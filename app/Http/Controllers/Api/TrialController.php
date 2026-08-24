<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Plan;
use App\Services\TrialService;
use Illuminate\Http\Request;
use RuntimeException;

class TrialController extends Controller
{
    public function __construct(
        private TrialService $trialService
    ) {
    }

    /**
     * Start the user's free trial.
     */
    public function start(Request $request)
    {
        $validated = $request->validate([
            'plan_id' => [
                'required',
                'exists:plans,id',
            ],

            'payment_provider' => [
                'required',
                'string',
                'max:100',
            ],

            'payment_method_id' => [
                'required',
                'string',
                'max:255',
            ],
        ]);

        try {
            $plan = Plan::findOrFail(
                $validated['plan_id']
            );

            $trial = $this->trialService->startTrial(
                $request->user(),
                $plan,
                $validated['payment_provider'],
                $validated['payment_method_id'],
            );

            return response()->json([
                'message' => 'Free trial started successfully.',
                'trial' => [
                    'id' => $trial->id,
                    'status' => $trial->status,
                    'is_trial' => $trial->is_trial,
                    'starts_at' => $trial->starts_at,
                    'trial_ends_at' => $trial->trial_ends_at,
                    'next_billing_at' => $trial->next_billing_at,
                    'payment_provider' => $trial->payment_provider,
                    'payment_method_verified' =>
                        $trial->payment_method_verified,
                    'plan' => $trial->load('plan')->plan,
                ],
            ], 201);

        } catch (RuntimeException $e) {
            return response()->json([
                'message' => $e->getMessage(),
            ], 422);
        }
    }

    /**
     * Get the user's current active trial.
     */
    public function current(Request $request)
    {
        $trial = $this->trialService->currentTrial(
            $request->user()
        );

        if (! $trial) {
            return response()->json([
                'message' => 'No active trial found.',
            ], 404);
        }

        return response()->json([
            'trial' => [
                'id' => $trial->id,
                'status' => $trial->status,
                'is_trial' => $trial->is_trial,
                'starts_at' => $trial->starts_at,
                'trial_ends_at' => $trial->trial_ends_at,
                'next_billing_at' => $trial->next_billing_at,
                'payment_provider' => $trial->payment_provider,
                'payment_method_verified' =>
                    $trial->payment_method_verified,
                'plan' => $trial->load('plan')->plan,
            ],
        ]);
    }
}