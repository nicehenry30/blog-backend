<?php

namespace App\Http\Controllers;

use App\Models\Trade;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class TradeController extends Controller
{
    /**
     * Get all trades belonging to the authenticated user.
     */
    public function index(Request $request): JsonResponse
    {
        $trades = $request->user()
            ->trades()
            ->latest()
            ->get();

        return response()->json([
            'message' => 'Trades retrieved successfully.',
            'trades' => $trades,
        ]);
    }

    /**
     * Store a new trade for the authenticated user.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'symbol' => ['required', 'string', 'max:20'],
            'direction' => ['required', 'in:BUY,SELL'],
            'entry' => ['required', 'numeric'],
            'exit' => ['required', 'numeric'],
            'result' => ['required', 'in:WIN,LOSS'],
            'profit_loss' => ['required', 'numeric'],
            'notes' => ['nullable', 'string'],
        ]);

        $trade = $request->user()
            ->trades()
            ->create($validated);

        return response()->json([
            'message' => 'Trade added successfully.',
            'trade' => $trade,
        ], 201);
    }

    /**
 * Update an existing trade belonging to the authenticated user.
 */
public function update(Request $request, Trade $trade): JsonResponse
{
    // Make sure the authenticated user owns this trade.
    if ($trade->user_id !== $request->user()->id) {
        return response()->json([
            'message' => 'Unauthorized.',
        ], 403);
    }

    $validated = $request->validate([
        'symbol' => ['required', 'string', 'max:20'],
        'direction' => ['required', 'in:BUY,SELL'],
        'entry' => ['required', 'numeric'],
        'exit' => ['required', 'numeric'],
        'result' => ['required', 'in:WIN,LOSS'],
        'profit_loss' => ['required', 'numeric'],
        'notes' => ['nullable', 'string'],
    ]);

    $trade->update($validated);

    return response()->json([
        'message' => 'Trade updated successfully.',
        'trade' => $trade->fresh(),
    ]);

  }
  /**
 * Delete an existing trade belonging to the authenticated user.
 */
public function destroy(Request $request, Trade $trade): JsonResponse
{
    // Make sure the authenticated user owns this trade.
    if ($trade->user_id !== $request->user()->id) {
        return response()->json([
            'message' => 'Unauthorized.',
        ], 403);
    }

    $trade->delete();

    return response()->json([
        'message' => 'Trade deleted successfully.',
    ]);
}
}