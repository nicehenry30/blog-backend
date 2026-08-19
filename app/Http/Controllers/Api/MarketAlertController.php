<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MarketAlert;
use App\Services\MarketAlertService;
use Illuminate\Http\Request;

class MarketAlertController extends Controller
{
    protected MarketAlertService $marketAlertService;

    public function __construct(
        MarketAlertService $marketAlertService
    ) {
        $this->marketAlertService = $marketAlertService;
    }

    /**
     * Display all market alerts.
     */
    public function index()
    {
        return response()->json([
            'data' => $this->marketAlertService->all(),
        ]);
    }

    /**
     * Display one market alert.
     */
    public function show(MarketAlert $marketAlert)
    {
        return response()->json([
            'data' => $marketAlert,
        ]);
    }

    /**
     * Store a new market alert.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'symbol' => 'required|string|max:20',
            'impact' => 'required|in:low,medium,high',
            'alert_time' => 'required|date',
            'recommendation' => 'required|string',
            'is_active' => 'boolean',
        ]);

        $alert = $this->marketAlertService
            ->create($validated);

        return response()->json([
            'message' => 'Market alert created successfully.',
            'data' => $alert,
        ], 201);
    }

    /**
     * Update an alert.
     */
    public function update(
        Request $request,
        MarketAlert $marketAlert
    ) {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'currency' => 'required|string|max:10',
            'impact' => 'required|in:low,medium,high',
            'alert_time' => 'required|date',
            'recommendation' => 'required|string',
            'is_active' => 'boolean',
        ]);

        $alert = $this->marketAlertService
            ->update(
                $marketAlert,
                $validated
            );

        return response()->json([
            'message' => 'Market alert updated successfully.',
            'data' => $alert,
        ]);
    }

    /**
     * Delete an alert.
     */
    public function destroy(
        MarketAlert $marketAlert
    ) {
        $this->marketAlertService
            ->delete($marketAlert);

        return response()->json([
            'message' => 'Market alert deleted successfully.',
        ]);
    }
}