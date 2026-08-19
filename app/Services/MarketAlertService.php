<?php

namespace App\Services;

use App\Models\MarketAlert;

class MarketAlertService
{
    /**
     * Get all active alerts.
     */
    public function all()
    {
        return MarketAlert::latest()->get();
    }

    /**
     * Create a market alert.
     */
    public function create(array $data): MarketAlert
    {
        return MarketAlert::create($data);
    }

    /**
     * Update a market alert.
     */
    public function update(
        MarketAlert $marketAlert,
        array $data
    ): MarketAlert {
        $marketAlert->update($data);

        return $marketAlert->fresh();
    }

    /**
     * Delete a market alert.
     */
    public function delete(
        MarketAlert $marketAlert
    ): void {
        $marketAlert->delete();
    }

    /**
     * Upcoming alerts.
     */
    public function upcoming()
    {
        return MarketAlert::where(
            'alert_time',
            '>',
            now()
        )
        ->where('is_active', true)
        ->orderBy('alert_time')
        ->get();
    }

    /**
     * Active alerts.
     */
    public function active()
    {
        return MarketAlert::where(
            'is_active',
            true
        )
        ->orderBy('alert_time')
        ->get();
    }
}