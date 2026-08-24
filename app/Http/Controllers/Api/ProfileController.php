<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class ProfileController extends Controller
{
    /**
     * Get the authenticated user's profile.
     */
    public function show(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,

                'mt4_connected' => $user->guardianAccounts()
                    ->where('platform', 'MT4')
                    ->where('is_connected', true)
                    ->exists(),

                'mt5_connected' => $user->guardianAccounts()
                    ->where('platform', 'MT5')
                    ->where('is_connected', true)
                    ->exists(),
            ],
        ], 200);
    }

    /**
     * Update the authenticated user's profile.
     */
    public function update(Request $request)
    {
        $user = $request->user();

        $validated = $request->validate([
            'name' => [
                'required',
                'string',
                'max:255',
            ],

            'email' => [
                'required',
                'email',
                'max:255',
                'unique:users,email,' . $user->id,
            ],
        ]);

        $user->update($validated);

        $user->refresh();

        return response()->json([
            'message' => 'Profile updated successfully',

            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,

                'mt4_connected' => $user->guardianAccounts()
                    ->where('platform', 'MT4')
                    ->where('is_connected', true)
                    ->exists(),

                'mt5_connected' => $user->guardianAccounts()
                    ->where('platform', 'MT5')
                    ->where('is_connected', true)
                    ->exists(),
            ],
        ], 200);
    }
}