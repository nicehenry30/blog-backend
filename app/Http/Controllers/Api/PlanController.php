<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\PlanResource;
use App\Models\Plan;

class PlanController extends Controller
{
    /**
     * Display all active subscription plans.
     */
    public function index()
    {
        $plans = Plan::with('features')
            ->where('is_active', true)
            ->orderBy('sort_order')
            ->get();

        return PlanResource::collection($plans);
    }

    /**
     * Display a specific subscription plan.
     */
    public function show(Plan $plan)
    {
        return new PlanResource(
            $plan->load('features')
        );
    }
}