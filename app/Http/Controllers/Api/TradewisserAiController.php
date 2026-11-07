<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\TradewisserAiService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class TradewisserAiController extends Controller
{
    public function __construct(
        private TradewisserAiService $tradewisserAiService
    ) {
    }

    public function marketAnalysis(
        Request $request
    ): JsonResponse {
        $validated = $request->validate([
            'symbol' => [
                'required',
                'string',
                'max:20',
            ],
            'account_balance' => [
                'required',
                'numeric',
                'gt:0',
            ],
            'risk_percent' => [
                'required',
                'numeric',
                'gt:0',
                'max:100',
            ],
        ]);

        $result = $this->tradewisserAiService->analyze(
            $validated['symbol'],
            (float) $validated['account_balance'],
            (float) $validated['risk_percent']
        );

        return response()->json([
            'success' => true,
            'data' => $result,
        ]);
    }
}