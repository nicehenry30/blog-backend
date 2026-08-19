<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\UserSetting;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class UserSettingController extends Controller
{
    /**
     * Get the authenticated user's settings.
     */
    public function show(Request $request): JsonResponse
    {
        $settings = UserSetting::firstOrCreate(
            [
                'user_id' => $request->user()->id,
            ],
            [
                'auto_trading_enabled' => false,
            ]
        );

        return response()->json([
            'auto_trading_enabled' => $settings->auto_trading_enabled,

            'minimum_signal_quality' => $settings->minimum_signal_quality,
            'minimum_ai_confidence' => $settings->minimum_ai_confidence,

            'allow_buy' => $settings->allow_buy,
            'allow_sell' => $settings->allow_sell,

            'require_ai_confirmation' =>
                $settings->require_ai_confirmation,

            'require_stop_loss' =>
                $settings->require_stop_loss,

            'require_take_profit' =>
                $settings->require_take_profit,
        ]);
    }

    /**
     * Update Auto Trading master switch.
     */
    public function updateAutoTrading(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'auto_trading_enabled' => ['required', 'boolean'],
        ]);

        $settings = UserSetting::updateOrCreate(
            [
                'user_id' => $request->user()->id,
            ],
            [
                'auto_trading_enabled' =>
                    $validated['auto_trading_enabled'],
            ]
        );

        return response()->json([
            'message' => $settings->auto_trading_enabled
                ? 'Auto Trading enabled.'
                : 'Auto Trading disabled.',

            'auto_trading_enabled' =>
                $settings->auto_trading_enabled,

            'minimum_signal_quality' =>
                $settings->minimum_signal_quality,

            'minimum_ai_confidence' =>
                $settings->minimum_ai_confidence,

            'allow_buy' => $settings->allow_buy,
            'allow_sell' => $settings->allow_sell,

            'require_ai_confirmation' =>
                $settings->require_ai_confirmation,

            'require_stop_loss' =>
                $settings->require_stop_loss,

            'require_take_profit' =>
                $settings->require_take_profit,
        ]);
    }

    /**
     * Update Auto Trading preferences.
     */
    public function updatePreferences(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'minimum_signal_quality' => [
                'sometimes',
                'numeric',
                'min:0',
                'max:100',
            ],

            'minimum_ai_confidence' => [
                'sometimes',
                'numeric',
                'min:0',
                'max:100',
            ],

            'allow_buy' => [
                'sometimes',
                'boolean',
            ],

            'allow_sell' => [
                'sometimes',
                'boolean',
            ],

            'require_ai_confirmation' => [
                'sometimes',
                'boolean',
            ],

            'require_stop_loss' => [
                'sometimes',
                'boolean',
            ],

            'require_take_profit' => [
                'sometimes',
                'boolean',
            ],
        ]);

        $settings = UserSetting::updateOrCreate(
            [
                'user_id' => $request->user()->id,
            ],
            $validated
        );

        return response()->json([
            'message' => 'Auto Trading preferences updated.',

            'auto_trading_enabled' =>
                $settings->auto_trading_enabled,

            'minimum_signal_quality' =>
                $settings->minimum_signal_quality,

            'minimum_ai_confidence' =>
                $settings->minimum_ai_confidence,

            'allow_buy' => $settings->allow_buy,
            'allow_sell' => $settings->allow_sell,

            'require_ai_confirmation' =>
                $settings->require_ai_confirmation,

            'require_stop_loss' =>
                $settings->require_stop_loss,

            'require_take_profit' =>
                $settings->require_take_profit,
        ]);
    }
}