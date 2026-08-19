<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Course;
use Illuminate\Http\JsonResponse;

class CourseController extends Controller
{
    /**
     * Get all published courses.
     */
    public function index(): JsonResponse
    {
        $courses = Course::where('is_published', true)
            ->orderBy('sort_order')
            ->orderBy('title')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $courses,
        ]);
    }

    /**
     * Get a single published course with its published lessons.
     */
    public function show(Course $course): JsonResponse
    {
        if (!$course->is_published) {
            return response()->json([
                'success' => false,
                'message' => 'Course not found.',
            ], 404);
        }

        $course->load([
            'lessons' => function ($query) {
                $query
                    ->where('is_published', true)
                    ->orderBy('lesson_order');
            },
        ]);

        return response()->json([
            'success' => true,
            'data' => $course,
        ]);
    }
}