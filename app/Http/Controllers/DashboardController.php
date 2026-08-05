<?php

namespace App\Http\Controllers;

use App\Models\RiskSetting;
use App\Models\Trade;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        // ================================================================
        // TRADING STATISTICS
        // ================================================================

        $trades = Trade::where('user_id', $user->id)->get();

        $totalTrades = $trades->count();

        $winningTrades = $trades
            ->where('result', 'WIN')
            ->count();

        $losingTrades = $trades
            ->where('result', 'LOSS')
            ->count();

        $winRate = $totalTrades > 0
            ? ($winningTrades / $totalTrades) * 100
            : 0;

        $totalProfit = $trades->sum('profit_loss');

        // ================================================================
        // RISK SETTINGS
        // ================================================================

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

        // ================================================================
        // DASHBOARD RESPONSE
        // ================================================================

        return response()->json([
            'stats' => [
                'total_trades' => $totalTrades,
                'winning_trades' => $winningTrades,
                'losing_trades' => $losingTrades,
                'win_rate' => round($winRate, 2),
                'total_profit' => round($totalProfit, 2),
            ],

            'risk' => [
                'risk_per_trade' => $riskSetting->risk_per_trade,
                'daily_loss_limit' => $riskSetting->daily_loss_limit,
                'max_drawdown' => $riskSetting->max_drawdown,
            ],
        ]);
    }
}