<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\GuardianAccount;
use App\Models\GuardianConnectionCode;
use App\Models\RiskSetting;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use App\Models\GuardianTradeExecution;


class GuardianController extends Controller
{
    /**
     * Get the authenticated user's Guardian account.
     */
    public function show(Request $request)
    {
        $user = $request->user();

        $guardianAccount = GuardianAccount::where(
            'user_id',
            $user->id
        )
            ->latest()
            ->first();

        if (!$guardianAccount) {
            return response()->json([
                'id' => null,
                'platform' => 'MT4',
                'account_number' => null,
                'broker' => null,
                'is_connected' => false,
                'is_enabled' => false,
                'balance' => 0.0,
                'equity' => 0.0,
                'current_drawdown' => 0.0,
                'open_positions' => 0,
                'daily_profit_loss' => 0.0,
                'last_seen_at' => null,
            ]);
        }

        return response()->json([
            'id' => $guardianAccount->id,
            'platform' => $guardianAccount->platform,
            'account_number' =>
                $guardianAccount->account_number,
            'broker' => $guardianAccount->broker,
            'is_connected' =>
                $guardianAccount->is_connected,
            'is_enabled' =>
                $guardianAccount->is_enabled,
            'balance' => $guardianAccount->balance,
            'equity' => $guardianAccount->equity,
            'current_drawdown' =>
                $guardianAccount->current_drawdown,
            'open_positions' =>
                $guardianAccount->open_positions,
            'daily_profit_loss' =>
                $guardianAccount->daily_profit_loss,
            'last_seen_at' =>
                $guardianAccount->last_seen_at,
        ]);
    }


    /**
     * Generate a temporary Guardian connection code.
     */
    public function generateConnectionCode(Request $request)
    {
        $validated = $request->validate([
            'platform' => [
                'required',
                'string',
                'in:MT4,MT5',
            ],
        ]);

        $user = $request->user();

        GuardianConnectionCode::where(
            'user_id',
            $user->id
        )
            ->where(
                'platform',
                $validated['platform']
            )
            ->where('is_used', false)
            ->delete();

        do {
            $code = 'TW-' . strtoupper(
                Str::random(6)
            );
        } while (
            GuardianConnectionCode::where(
                'code',
                $code
            )->exists()
        );

        $connectionCode =
            GuardianConnectionCode::create([
                'user_id' => $user->id,
                'code' => $code,
                'platform' => $validated['platform'],
                'is_used' => false,
                'expires_at' => now()->addMinutes(15),
            ]);

        return response()->json([
            'message' =>
                'Guardian connection code generated successfully.',
            'code' => $connectionCode->code,
            'platform' => $connectionCode->platform,
            'expires_at' => $connectionCode->expires_at,
            'expires_in_minutes' => 15,
        ], 201);
    }


    /**
     * Connect an MT4/MT5 Guardian EA using
     * a temporary connection code.
     */
    public function connect(Request $request)
    {
        $validated = $request->validate([
            'code' => [
                'required',
                'string',
            ],

            'platform' => [
                'required',
                'string',
                'in:MT4,MT5',
            ],

            'account_number' => [
                'required',
                'string',
                'max:50',
            ],

            'broker' => [
                'required',
                'string',
                'max:255',
            ],

            'balance' => [
                'required',
                'numeric',
                'min:0',
            ],

            'equity' => [
                'required',
                'numeric',
                'min:0',
            ],
        ]);

        $code = strtoupper(
            trim($validated['code'])
        );

        $connectionCode =
            GuardianConnectionCode::where(
                'code',
                $code
            )->first();

        if (!$connectionCode) {
            return response()->json([
                'message' =>
                    'Invalid Guardian connection code.',
            ], 404);
        }

        if ($connectionCode->is_used) {
            return response()->json([
                'message' =>
                    'This Guardian connection code has already been used.',
            ], 409);
        }

        if ($connectionCode->isExpired()) {
            return response()->json([
                'message' =>
                    'This Guardian connection code has expired.',
            ], 410);
        }

        if (
            $connectionCode->platform !==
            $validated['platform']
        ) {
            return response()->json([
                'message' =>
                    'The selected platform does not match the connection code.',
            ], 422);
        }

        $deviceToken = Str::random(64);

        $deviceTokenHash = hash(
            'sha256',
            $deviceToken
        );

        $guardianAccount =
            GuardianAccount::updateOrCreate(
                [
                    'user_id' =>
                        $connectionCode->user_id,

                    'platform' =>
                        $validated['platform'],

                    'account_number' =>
                        $validated['account_number'],
                ],
                [
                    'broker' =>
                        $validated['broker'],

                    'device_token_hash' =>
                        $deviceTokenHash,

                    'is_connected' => true,

                    'is_enabled' => true,

                    'balance' =>
                        $validated['balance'],

                    'equity' =>
                        $validated['equity'],

                    'current_drawdown' => 0,

                    'open_positions' => 0,

                    'daily_profit_loss' => 0,

                    'last_seen_at' => now(),
                ]
            );

        $connectionCode->update([
            'is_used' => true,
            'used_at' => now(),
        ]);

        return response()->json([
            'message' =>
                'Guardian account connected successfully.',

            'device_token' => $deviceToken,

            'guardian_account' => [
                'id' =>
                    $guardianAccount->id,

                'platform' =>
                    $guardianAccount->platform,

                'account_number' =>
                    $guardianAccount->account_number,

                'broker' =>
                    $guardianAccount->broker,

                'is_connected' =>
                    $guardianAccount->is_connected,

                'is_enabled' =>
                    $guardianAccount->is_enabled,
            ],
        ], 200);
    }


    /**
     * Receive live account updates from
     * the MT4/MT5 Guardian EA.
     */
    public function heartbeat(Request $request)
    {
        $validated = $request->validate([
            'platform' => [
                'required',
                'string',
                'in:MT4,MT5',
            ],

            'account_number' => [
                'required',
                'string',
                'max:50',
            ],

            'device_token' => [
                'required',
                'string',
                'size:64',
            ],

            'balance' => [
                'required',
                'numeric',
                'min:0',
            ],

            'equity' => [
                'required',
                'numeric',
                'min:0',
            ],

            'current_drawdown' => [
                'required',
                'numeric',
                'min:0',
            ],

            'open_positions' => [
                'required',
                'integer',
                'min:0',
            ],

            'daily_profit_loss' => [
                'required',
                'numeric',
            ],
        ]);

        $deviceTokenHash = hash(
            'sha256',
            $validated['device_token']
        );

        $guardianAccount =
            GuardianAccount::where(
                'platform',
                $validated['platform']
            )
                ->where(
                    'account_number',
                    $validated['account_number']
                )
                ->where(
                    'device_token_hash',
                    $deviceTokenHash
                )
                ->first();

        if (!$guardianAccount) {
            return response()->json([
                'message' =>
                    'Invalid Guardian device credentials.',
            ], 401);
        }

        $guardianAccount->update([
            'balance' =>
                $validated['balance'],

            'equity' =>
                $validated['equity'],

            'current_drawdown' =>
                $validated['current_drawdown'],

            'open_positions' =>
                $validated['open_positions'],

            'daily_profit_loss' =>
                $validated['daily_profit_loss'],

            'is_connected' => true,

            'last_seen_at' => now(),
        ]);

        return response()->json([
            'message' =>
                'Guardian heartbeat received successfully.',

            'guardian_account' => [
                'id' =>
                    $guardianAccount->id,

                'platform' =>
                    $guardianAccount->platform,

                'account_number' =>
                    $guardianAccount->account_number,

                'balance' =>
                    $guardianAccount->balance,

                'equity' =>
                    $guardianAccount->equity,

                'current_drawdown' =>
                    $guardianAccount->current_drawdown,

                'open_positions' =>
                    $guardianAccount->open_positions,

                'daily_profit_loss' =>
                    $guardianAccount->daily_profit_loss,

                'is_connected' =>
                    $guardianAccount->is_connected,

                'is_enabled' =>
                    $guardianAccount->is_enabled,

                'last_seen_at' =>
                    $guardianAccount->last_seen_at,
            ],
        ]);
    }


    /**
     * Get risk settings for an authenticated
     * Guardian EA/device.
     */
    public function riskSettings(Request $request)
    {
        $validated = $request->validate([
            'platform' => [
                'required',
                'string',
                'in:MT4,MT5',
            ],

            'account_number' => [
                'required',
                'string',
                'max:50',
            ],

            'device_token' => [
                'required',
                'string',
                'size:64',
            ],
        ]);

        // Hash the raw token supplied by the EA.
        $deviceTokenHash = hash(
            'sha256',
            $validated['device_token']
        );

        // Authenticate the Guardian installation.
        $guardianAccount =
            GuardianAccount::where(
                'platform',
                $validated['platform']
            )
                ->where(
                    'account_number',
                    $validated['account_number']
                )
                ->where(
                    'device_token_hash',
                    $deviceTokenHash
                )
                ->first();

        if (!$guardianAccount) {
            return response()->json([
                'message' =>
                    'Invalid Guardian device credentials.',
            ], 401);
        }

        // Get the risk settings belonging to the
        // Tradewisser user who owns this Guardian account.
        $riskSetting = RiskSetting::firstOrCreate(
            [
                'user_id' =>
                    $guardianAccount->user_id,
            ],
            [
                'risk_per_trade' => 1.00,
                'daily_loss_limit' => 2.00,
                'max_drawdown' => 5.00,
            ]
        );

        return response()->json([
            'risk_per_trade' =>
                $riskSetting->risk_per_trade,

            'daily_loss_limit' =>
                $riskSetting->daily_loss_limit,

            'max_drawdown' =>
                $riskSetting->max_drawdown,
        ]);
    }


    /**
     * Disconnect the authenticated user's
     * Guardian account.
     */
    public function disconnect(Request $request)
    {
        $user = $request->user();

        $guardianAccount =
            GuardianAccount::where(
                'user_id',
                $user->id
            )
                ->where(
                    'is_connected',
                    true
                )
                ->latest()
                ->first();

        if (!$guardianAccount) {
            return response()->json([
                'message' =>
                    'No connected Guardian account was found.',
            ], 404);
        }

        $guardianAccount->update([
            'is_connected' => false,
            'is_enabled' => false,

            // Immediately invalidate the EA credential.
            'device_token_hash' => null,

            'open_positions' => 0,
            'last_seen_at' => now(),
        ]);

        GuardianConnectionCode::where(
            'user_id',
            $user->id
        )
            ->where(
                'is_used',
                false
            )
            ->delete();

        return response()->json([
            'message' =>
                'Guardian account disconnected successfully.',

            'guardian_account' => [
                'id' =>
                    $guardianAccount->id,

                'platform' =>
                    $guardianAccount->platform,

                'account_number' =>
                    $guardianAccount->account_number,

                'is_connected' =>
                    $guardianAccount->is_connected,

                'is_enabled' =>
                    $guardianAccount->is_enabled,
            ],
        ]);
    }

    /**
 * Record an Auto Trading execution result from Guardian EA.
 */
public function autoTradeResult(Request $request): JsonResponse
{
    $validated = $request->validate([
        'platform' => [
            'required',
            'string',
            'in:MT4,MT5',
        ],

        'account_number' => [
            'required',
            'string',
        ],

        'device_token' => [
            'required',
            'string',
        ],

        'signal_id' => [
            'nullable',
            'integer',
            'exists:signals,id',
        ],

        'ticket' => [
            'nullable',
            'string',
        ],

        'symbol' => [
            'required',
            'string',
        ],

        'direction' => [
            'required',
            'string',
            'in:BUY,SELL',
        ],

        'lots' => [
            'nullable',
            'numeric',
            'min:0',
        ],

        'entry_price' => [
            'nullable',
            'numeric',
        ],

        'stop_loss' => [
            'nullable',
            'numeric',
        ],

        'take_profit' => [
            'nullable',
            'numeric',
        ],

        'status' => [
            'required',
            'string',
            'in:executed,rejected,failed',
        ],

        'reason' => [
            'nullable',
            'string',
            'max:1000',
        ],

        'error_code' => [
            'nullable',
            'integer',
        ],

        'executed_at' => [
            'nullable',
            'date',
        ],
    ]);

        // -------------------------------------------------------------
        // Authenticate Guardian device
        // -------------------------------------------------------------

        $deviceTokenHash = hash(
            'sha256',
            $validated['device_token']
        );

        $guardianAccount = GuardianAccount::where(
            'platform',
            $validated['platform']
        )
            ->where(
                'account_number',
                $validated['account_number']
            )
            ->where(
                'device_token_hash',
                $deviceTokenHash
            )
            ->first();

        if (!$guardianAccount) {
            return response()->json([
                'message' => 'Invalid Guardian credentials.',
            ], 401);
        }

        // -------------------------------------------------------------
        // Store execution result
        // -------------------------------------------------------------

        $execution = GuardianTradeExecution::create([
            'guardian_account_id' => $guardianAccount->id,

            'signal_id' =>
                $validated['signal_id'] ?? null,

            'ticket' =>
                $validated['ticket'] ?? null,

            'platform' =>
                $validated['platform'],

            'symbol' =>
                $validated['symbol'],

            'direction' =>
                $validated['direction'],

            'lots' =>
                $validated['lots'] ?? null,

            'entry_price' =>
                $validated['entry_price'] ?? null,

            'stop_loss' =>
                $validated['stop_loss'] ?? null,

            'take_profit' =>
                $validated['take_profit'] ?? null,

            'status' =>
                $validated['status'],

            'reason' =>
                $validated['reason'] ?? null,

            'error_code' =>
                $validated['error_code'] ?? null,

            'executed_at' =>
                $validated['executed_at'] ?? now(),
        ]);

        return response()->json([
            'message' =>
                'Guardian auto-trade result recorded.',

            'execution_id' =>
                $execution->id,

            'status' =>
                $execution->status,
        ], 201);
    }
}