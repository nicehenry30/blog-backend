<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Feedback;
use Illuminate\Http\Request;

class FeedbackController extends Controller
{
    /**
     * Get all feedback submitted by the authenticated user.
     */
    public function index(Request $request)
    {
        $feedback = $request->user()
            ->feedback()
            ->latest()
            ->get();

        return response()->json([
            'data' => $feedback,
        ]);
    }

    /**
     * Submit new feedback.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'category' => [
                'required',
                'string',
                'in:general,bug,signal,education,guardian,payment,other',
            ],
            'subject' => [
                'required',
                'string',
                'max:255',
            ],
            'message' => [
                'required',
                'string',
                'max:5000',
            ],
        ]);

        $feedback = $request->user()
            ->feedback()
            ->create([
                'category' => $validated['category'],
                'subject' => $validated['subject'],
                'message' => $validated['message'],
                'status' => 'pending',
            ]);

        return response()->json([
            'message' => 'Feedback submitted successfully.',
            'data' => $feedback,
        ], 201);
    }

    /**
     * Show one feedback belonging to the authenticated user.
     */
    public function show(
        Request $request,
        Feedback $feedback
    ) {
        /*
         * Prevent users from viewing another
         * user's feedback.
         */
        if ($feedback->user_id !== $request->user()->id) {
            return response()->json([
                'message' => 'Unauthorized.',
            ], 403);
        }

        return response()->json([
            'data' => $feedback,
        ]);
    }
}