<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Course;
use App\Models\Lesson;
use Illuminate\Http\Request;

class LessonController extends Controller
{
    /**
     * Display all lessons.
     */
    public function index()
    {
        $lessons = Lesson::with('course')
            ->orderBy('course_id')
            ->orderBy('lesson_order')
            ->paginate(15);

        return view(
            'admin.lessons.index',
            compact('lessons')
        );
    }

    /**
     * Show the form for creating a new lesson.
     */
    public function create()
    {
        $courses = Course::orderBy('sort_order')
            ->orderBy('title')
            ->get();

        return view(
            'admin.lessons.create',
            compact('courses')
        );
    }

    /**
     * Store a new lesson.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'course_id' => 'required|exists:courses,id',

            'title' => 'required|string|max:255',

            'description' => 'nullable|string',

            'video_url' => 'nullable|url|max:2048',

            'lesson_order' => 'nullable|integer|min:0',

            'is_published' => 'nullable|boolean',
        ]);

        $validated['is_published'] =
            $request->boolean('is_published');

        $validated['lesson_order'] =
            $validated['lesson_order'] ?? 0;

        Lesson::create($validated);

        return redirect()
            ->route('admin.lessons.index')
            ->with(
                'success',
                'Lesson created successfully.'
            );
    }

    /**
     * Display a single lesson.
     */
    public function show(Lesson $lesson)
    {
        $lesson->load('course');

        return view(
            'admin.lessons.show',
            compact('lesson')
        );
    }

    /**
     * Show the form for editing a lesson.
     */
    public function edit(Lesson $lesson)
    {
        $courses = Course::orderBy('sort_order')
            ->orderBy('title')
            ->get();

        return view(
            'admin.lessons.edit',
            compact(
                'lesson',
                'courses'
            )
        );
    }

    /**
     * Update an existing lesson.
     */
    public function update(
        Request $request,
        Lesson $lesson
    ) {
        $validated = $request->validate([
            'course_id' => 'required|exists:courses,id',

            'title' => 'required|string|max:255',

            'description' => 'nullable|string',

            'video_url' => 'nullable|url|max:2048',

            'lesson_order' => 'nullable|integer|min:0',

            'is_published' => 'nullable|boolean',
        ]);

        $validated['is_published'] =
            $request->boolean('is_published');

        $validated['lesson_order'] =
            $validated['lesson_order'] ?? 0;

        $lesson->update($validated);

        return redirect()
            ->route('admin.lessons.index')
            ->with(
                'success',
                'Lesson updated successfully.'
            );
    }

    /**
     * Delete a lesson.
     */
    public function destroy(Lesson $lesson)
    {
        $lesson->delete();

        return redirect()
            ->route('admin.lessons.index')
            ->with(
                'success',
                'Lesson deleted successfully.'
            );
    }
}