<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\MarketAlert;
use Illuminate\Http\Request;

class MarketAlertController extends Controller
{
     public function index()
    {
        $alerts = MarketAlert::latest('alert_time')
            ->paginate(15);

        $activeAlerts = MarketAlert::where('is_active', true)
            ->count();

        $highImpactAlerts = MarketAlert::where('impact', 'high')
            ->where('is_active', true)
            ->count();

        return view(
            'admin.market_alerts.index',
            compact(
                'alerts',
                'activeAlerts',
                'highImpactAlerts'
            )
        );
    }
    public function create()
    {
        return view('admin.market_alerts.create');
    }

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

        MarketAlert::create($validated);

        return redirect()
            ->route('admin.market-alerts.index')
            ->with(
                'success',
                'Market alert created successfully.'
            );
    }

    public function show(MarketAlert $marketAlert)
    {
        return view(
            'admin.market_alerts.show',
            compact('marketAlert')
        );
    }

    public function edit(MarketAlert $marketAlert)
    {
        return view(
            'admin.market_alerts.edit',
            compact('marketAlert')
        );
    }

    public function update(
        Request $request,
        MarketAlert $marketAlert
    ) {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'symbol' => 'required|string|max:20',
            'impact' => 'required|in:low,medium,high',
            'alert_time' => 'required|date',
            'recommendation' => 'required|string',
            'is_active' => 'boolean',
        ]);

        $marketAlert->update($validated);

        return redirect()
            ->route('admin.market-alerts.index')
            ->with(
                'success',
                'Market alert updated successfully.'
            );
    }

    public function destroy(
        MarketAlert $marketAlert
    ) {
        $marketAlert->delete();

        return redirect()
            ->route('admin.market-alerts.index')
            ->with(
                'success',
                'Market alert deleted successfully.'
            );
    }
}