<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Feedback;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class FeedbackController extends Controller
{
    /**
     * Display all user feedback.
     */
    public function index(): View
    {
        $feedback = Feedback::with('user')
            ->latest()
            ->paginate(15);

        return view(
            'admin.feedback.index',
            compact('feedback')
        );
    }

    /**
     * Display a single feedback item.
     */
    public function show(Feedback $feedback): View
    {
        $feedback->load('user');

        return view(
            'admin.feedback.show',
            compact('feedback')
        );
    }

    /**
     * Reply to feedback and update its status.
     */
    public function update(
        Request $request,
        Feedback $feedback
    ): RedirectResponse {
        $validated = $request->validate([
            'admin_reply' => [
                'nullable',
                'string',
                'max:5000',
            ],
            'status' => [
                'required',
                'in:pending,in_progress,resolved,closed',
            ],
        ]);

        $updateData = [
            'status' => $validated['status'],
        ];

        /*
         * If the admin supplied a reply, save it
         * and record when the reply was made.
         */
        if (
            isset($validated['admin_reply']) &&
            trim($validated['admin_reply']) !== ''
        ) {
            $updateData['admin_reply'] =
                trim($validated['admin_reply']);

            $updateData['replied_at'] = now();
        }

        $feedback->update($updateData);

        return redirect()
            ->route(
                'admin.feedback.show',
                $feedback
            )
            ->with(
                'success',
                'Feedback updated successfully.'
            );
    }
}