<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Course;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class CourseController extends Controller
{
    /**
     * Display all courses.
     */
    public function index()
    {
        $courses = Course::orderBy('sort_order')
            ->latest()
            ->paginate(15);

        $totalCourses = Course::count();

        $publishedCourses = Course::where(
            'is_published',
            true
        )->count();

        $draftCourses = Course::where(
            'is_published',
            false
        )->count();

        return view(
            'admin.courses.index',
            compact(
                'courses',
                'totalCourses',
                'publishedCourses',
                'draftCourses'
            )
        );
    }

    /**
     * Show the course creation form.
     */
    public function create()
    {
        return view('admin.courses.create');
    }

    /**
     * Store a new course.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',

            'description' => 'nullable|string',

            'thumbnail' => 'nullable|string|max:255',

            'category' => 'nullable|string|max:100',

            'level' => [
                'required',
                'in:beginner,intermediate,advanced',
            ],

            'is_published' => 'nullable|boolean',

            'sort_order' => 'nullable|integer|min:0',
        ]);

        $validated['slug'] = Str::slug(
            $validated['title']
        );

        $validated['is_published'] =
            $request->boolean('is_published');

        $validated['sort_order'] =
            $validated['sort_order'] ?? 0;

        Course::create($validated);

        return redirect()
            ->route('admin.courses.index')
            ->with(
                'success',
                'Course created successfully.'
            );
    }

    /**
     * Display a single course.
     */
    public function show(Course $course)
    {
        return view(
            'admin.courses.show',
            compact('course')
        );
    }

    /**
     * Show the course edit form.
     */
    public function edit(Course $course)
    {
        return view(
            'admin.courses.edit',
            compact('course')
        );
    }

    /**
     * Update an existing course.
     */
    public function update(
        Request $request,
        Course $course
    ) {
        $validated = $request->validate([
            'title' => 'required|string|max:255',

            'description' => 'nullable|string',

            'thumbnail' => 'nullable|string|max:255',

            'category' => 'nullable|string|max:100',

            'level' => [
                'required',
                'in:beginner,intermediate,advanced',
            ],

            'is_published' => 'nullable|boolean',

            'sort_order' => 'nullable|integer|min:0',
        ]);

        $validated['slug'] = Str::slug(
            $validated['title']
        );

        $validated['is_published'] =
            $request->boolean('is_published');

        $validated['sort_order'] =
            $validated['sort_order'] ?? 0;

        $course->update($validated);

        return redirect()
            ->route('admin.courses.index')
            ->with(
                'success',
                'Course updated successfully.'
            );
    }

    /**
     * Delete a course.
     */
    public function destroy(Course $course)
    {
        $course->delete();

        return redirect()
            ->route('admin.courses.index')
            ->with(
                'success',
                'Course deleted successfully.'
            );
    }
}