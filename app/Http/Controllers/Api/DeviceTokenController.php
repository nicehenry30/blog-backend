<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\UserDevice;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DeviceTokenController extends Controller
{
    /**
     * Register or update the authenticated user's FCM device token.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'fcm_token' => ['required', 'string', 'max:2048'],
            'platform' => ['nullable', 'string', 'in:ios,android,web'],
            'device_name' => ['nullable', 'string', 'max:255'],
        ]);

        $device = UserDevice::updateOrCreate(
            [
                'fcm_token' => $validated['fcm_token'],
            ],
            [
                'user_id' => $request->user()->id,
                'platform' => $validated['platform'] ?? null,
                'device_name' => $validated['device_name'] ?? null,
                'last_used_at' => now(),
            ]
        );

        return response()->json([
            'message' => 'Device token registered successfully.',
            'device' => $device,
        ]);
    }

    /**
     * Remove the authenticated user's FCM device token.
     */
    public function destroy(Request $request): JsonResponse
    {
        $request->validate([
            'fcm_token' => ['required', 'string', 'max:2048'],
        ]);

        UserDevice::where('user_id', $request->user()->id)
            ->where('fcm_token', $request->fcm_token)
            ->delete();

        return response()->json([
            'message' => 'Device token removed successfully.',
        ]);
    }
}