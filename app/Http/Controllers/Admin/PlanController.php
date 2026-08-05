<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\StorePlanRequest;
use App\Http\Requests\UpdatePlanRequest;
use App\Models\Plan;

class PlanController extends Controller
{
    /**
     * Display all subscription plans.
     */
    public function index()
    {
        $plans = Plan::withCount('features')
            ->orderBy('sort_order')
            ->paginate(15);

        return view('admin.plans.index', compact('plans'));
    }

    /**
     * Show the form for creating a new plan.
     */
    public function create()
    {
        return view('admin.plans.create');
    }

    /**
     * Store a newly created plan.
     */
    public function store(StorePlanRequest $request)
    {
        Plan::create(
            $request->validated()
        );

        return redirect()
            ->route('admin.plans.index')
            ->with(
                'success',
                'Plan created successfully.'
            );
    }

    /**
     * Display the specified plan.
     */
    public function show(Plan $plan)
    {
        return view(
            'admin.plans.show',
            compact('plan')
        );
    }

    /**
     * Show the form for editing the specified plan.
     */
    public function edit(Plan $plan)
    {
        return view(
            'admin.plans.edit',
            compact('plan')
        );
    }

    /**
     * Update the specified plan.
     */
    public function update(
        UpdatePlanRequest $request,
        Plan $plan
    ) {
        $plan->update(
            $request->validated()
        );

        return redirect()
            ->route('admin.plans.index')
            ->with(
                'success',
                'Plan updated successfully.'
            );
    }

    /**
     * Remove the specified plan.
     */
    public function destroy(Plan $plan)
    {
        $plan->delete();

        return redirect()
            ->route('admin.plans.index')
            ->with(
                'success',
                'Plan deleted successfully.'
            );
    }
}