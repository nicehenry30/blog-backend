<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'unique:users,email'],
            'password' => ['required', 'string', 'min:8'],
            'referral_code' => ['nullable', 'string', 'max:20'],
        ]);

        /*
        |--------------------------------------------------------------------------
        | Find Referrer
        |--------------------------------------------------------------------------
        */

        $referrer = null;

        if (!empty($validated['referral_code'])) {
            $referrer = User::where(
                'referral_code',
                $validated['referral_code']
            )->first();

            if (!$referrer) {
                return response()->json([
                    'message' => 'The referral code is invalid.',
                    'errors' => [
                        'referral_code' => [
                            'The referral code is invalid.',
                        ],
                    ],
                ], 422);
            }
        }

        /*
        |--------------------------------------------------------------------------
        | Generate Unique Referral Code For New User
        |--------------------------------------------------------------------------
        */

        do {
            $referralCode = strtoupper(
                substr(bin2hex(random_bytes(5)), 0, 8)
            );
        } while (
            User::where('referral_code', $referralCode)->exists()
        );

        /*
        |--------------------------------------------------------------------------
        | Create User
        |--------------------------------------------------------------------------
        */

        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'referral_code' => $referralCode,
            'referred_by_user_id' => $referrer?->id,
        ]);

        /*
        |--------------------------------------------------------------------------
        | Create Referral Record
        |--------------------------------------------------------------------------
        */

        if ($referrer) {
            $user->referredBy()->create([
                'referrer_id' => $referrer->id,
                'referred_user_id' => $user->id,
                'referral_code' => $referrer->referral_code,
                'reward_amount' => 0,
                'reward_currency' => 'USD',
                'status' => 'pending',
            ]);
        }

        /*
        |--------------------------------------------------------------------------
        | Create Authentication Token
        |--------------------------------------------------------------------------
        */

        $token = $user
            ->createToken('auth_token')
            ->plainTextToken;

        return response()->json([
            'message' => 'User registered successfully',
            'user' => $user,
            'token' => $token,
        ], 201);
    }

    public function login(Request $request)
    {
        $validated = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required', 'string'],
        ]);

        $user = User::where(
            'email',
            $validated['email']
        )->first();

        if (
            !$user ||
            !Hash::check(
                $validated['password'],
                $user->password
            )
        ) {
            throw ValidationException::withMessages([
                'email' => [
                    'The provided credentials are incorrect.',
                ],
            ]);
        }

        $token = $user
            ->createToken('auth_token')
            ->plainTextToken;

        return response()->json([
            'message' => 'Login successful',
            'user' => $user,
            'token' => $token,
        ], 200);
    }

    public function logout(Request $request)
    {
        $request
            ->user()
            ->currentAccessToken()
            ->delete();

        return response()->json([
            'message' => 'Logout successful',
        ]);
    }
}