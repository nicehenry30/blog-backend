<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\ReferralService;
use Illuminate\Http\Request;

class ReferralController extends Controller
{
    public function __construct(
        private ReferralService $referralService
    ) {
    }

    /**
     * Get the authenticated user's referral summary.
     */
    public function summary(Request $request)
    {
        $user = $request->user();

        $referrals = $this->referralService
            ->getUserReferrals($user);

        return response()->json([
            'referral_code' => $user->referral_code,

            'total_referrals' => $referrals->count(),

            'pending' => $referrals
                ->where('status', 'pending')
                ->count(),

            'qualified' => $referrals
                ->where('status', 'qualified')
                ->count(),

            'rewarded' => $referrals
                ->where('status', 'rewarded')
                ->count(),

            'total_rewards' => number_format(
                (float) $referrals->sum('reward_amount'),
                2,
                '.',
                ''
            ),

            'reward_currency' => 'USD',
        ]);
    }

    /**
     * Get all referrals made by the authenticated user.
     */
    public function index(Request $request)
    {
        $referrals = $this->referralService
            ->getUserReferrals($request->user());

        return response()->json([
            'data' => $referrals->map(
                function ($referral) {
                    return [
                        'id' => $referral->id,

                        'referral_code' =>
                            $referral->referral_code,

                        'status' =>
                            $referral->status,

                        'reward_amount' =>
                            $referral->reward_amount,

                        'reward_currency' =>
                            $referral->reward_currency,

                        'qualified_at' =>
                            $referral->qualified_at,

                        'rewarded_at' =>
                            $referral->rewarded_at,

                        'referred_user' => $referral
                            ->referredUser
                            ? [
                                'id' =>
                                    $referral->referredUser->id,

                                'name' =>
                                    $referral->referredUser->name,

                                'email' =>
                                    $referral->referredUser->email,
                            ]
                            : null,
                    ];
                }
            ),
        ]);
    }
}