<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Lesson;
use Illuminate\Http\JsonResponse;

class LessonController extends Controller
{
    /**
     * Get a single published lesson.
     */
    public function show(Lesson $lesson): JsonResponse
    {
        if (
            !$lesson->is_published ||
            !$lesson->course ||
            !$lesson->course->is_published
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Lesson not found.',
            ], 404);
        }

        $lesson->load('course');

        return response()->json([
            'success' => true,
            'data' => $lesson,
        ]);
    }
}