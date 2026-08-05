<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\RiskSetting;
use Illuminate\Http\Request;

class RiskSettingController extends Controller
{
    /**
     * Get the authenticated user's risk settings.
     */
    public function show(Request $request)
    {
        $user = $request->user();

        $riskSetting = RiskSetting::firstOrCreate(
            [
                'user_id' => $user->id,
            ],
            [
                'risk_per_trade' => 1.00,
                'daily_loss_limit' => 2.00,
                'max_drawdown' => 5.00,
            ]
        );

        return response()->json([
            'risk_per_trade' => $riskSetting->risk_per_trade,
            'daily_loss_limit' => $riskSetting->daily_loss_limit,
            'max_drawdown' => $riskSetting->max_drawdown,
        ]);
    }

    /**
     * Update the authenticated user's risk settings.
     */
    public function update(Request $request)
    {
        $validated = $request->validate([
            'risk_per_trade' => [
                'required',
                'numeric',
                'min:0.01',
                'max:100',
            ],
            'daily_loss_limit' => [
                'required',
                'numeric',
                'min:0.01',
                'max:100',
            ],
            'max_drawdown' => [
                'required',
                'numeric',
                'min:0.01',
                'max:100',
            ],
        ]);

        $user = $request->user();

        $riskSetting = RiskSetting::updateOrCreate(
            [
                'user_id' => $user->id,
            ],
            [
                'risk_per_trade' => $validated['risk_per_trade'],
                'daily_loss_limit' => $validated['daily_loss_limit'],
                'max_drawdown' => $validated['max_drawdown'],
            ]
        );

        return response()->json([
            'message' => 'Risk settings updated successfully.',
            'risk_per_trade' => $riskSetting->risk_per_trade,
            'daily_loss_limit' => $riskSetting->daily_loss_limit,
            'max_drawdown' => $riskSetting->max_drawdown,
        ]);
    }
}