@extends('layouts.app')

@section('title', 'Create Lesson')

@section('content')

<div class="max-w-4xl mx-auto space-y-6">

    {{-- Page Header --}}

    <div>

        <h1 class="text-3xl font-bold text-gray-900">
            Create Lesson
        </h1>

        <p class="mt-2 text-gray-500">
            Add a new lesson and video tutorial to a course.
        </p>

    </div>


    {{-- Form --}}

    <x-admin.card title="Lesson Information">

        <form
            method="POST"
            action="{{ route('admin.lessons.store') }}"
            class="space-y-6"
        >

            @csrf


            {{-- Course --}}

            <div>

                <label
                    for="course_id"
                    class="block text-sm font-semibold text-gray-700 mb-2"
                >
                    Course
                </label>

                <select
                    id="course_id"
                    name="course_id"
                    class="w-full border border-gray-300 rounded-lg px-4 py-3
                           focus:ring-2 focus:ring-blue-500
                           focus:border-blue-500"
                    required
                >

                    <option value="">
                        Select a course
                    </option>

                    @foreach($courses as $course)

                        <option
                            value="{{ $course->id }}"
                            @selected(old('course_id') == $course->id)
                        >
                            {{ $course->title }}
                        </option>

                    @endforeach

                </select>

                @error('course_id')
                    <p class="mt-1 text-sm text-red-600">
                        {{ $message }}
                    </p>
                @enderror

            </div>


            {{-- Lesson Title --}}

            <div>

                <label
                    for="title"
                    class="block text-sm font-semibold text-gray-700 mb-2"
                >
                    Lesson Title
                </label>

                <input
                    type="text"
                    id="title"
                    name="title"
                    value="{{ old('title') }}"
                    placeholder="e.g. Understanding Currency Pairs"
                    class="w-full border border-gray-300 rounded-lg px-4 py-3
                           focus:ring-2 focus:ring-blue-500
                           focus:border-blue-500"
                    required
                >

                @error('title')
                    <p class="mt-1 text-sm text-red-600">
                        {{ $message }}
                    </p>
                @enderror

            </div>


            {{-- Description --}}

            <div>

                <label
                    for="description"
                    class="block text-sm font-semibold text-gray-700 mb-2"
                >
                    Lesson Description
                </label>

                <textarea
                    id="description"
                    name="description"
                    rows="5"
                    placeholder="Briefly explain what this lesson teaches..."
                    class="w-full border border-gray-300 rounded-lg px-4 py-3
                           focus:ring-2 focus:ring-blue-500
                           focus:border-blue-500"
                >{{ old('description') }}</textarea>

                @error('description')
                    <p class="mt-1 text-sm text-red-600">
                        {{ $message }}
                    </p>
                @enderror

            </div>


            {{-- Video Tutorial --}}

            <div>

                <label
                    for="video_url"
                    class="block text-sm font-semibold text-gray-700 mb-2"
                >
                    Video Tutorial URL
                </label>

                <input
                    type="url"
                    id="video_url"
                    name="video_url"
                    value="{{ old('video_url') }}"
                    placeholder="https://..."
                    class="w-full border border-gray-300 rounded-lg px-4 py-3
                           focus:ring-2 focus:ring-blue-500
                           focus:border-blue-500"
                >

                <p class="mt-1 text-sm text-gray-500">
                    Add the URL of the video tutorial for this lesson.
                </p>

                @error('video_url')
                    <p class="mt-1 text-sm text-red-600">
                        {{ $message }}
                    </p>
                @enderror

            </div>


            {{-- Lesson Order --}}

            <div>

                <label
                    for="lesson_order"
                    class="block text-sm font-semibold text-gray-700 mb-2"
                >
                    Lesson Order
                </label>

                <input
                    type="number"
                    id="lesson_order"
                    name="lesson_order"
                    value="{{ old('lesson_order', 0) }}"
                    min="0"
                    class="w-full border border-gray-300 rounded-lg px-4 py-3
                           focus:ring-2 focus:ring-blue-500
                           focus:border-blue-500"
                >

                <p class="mt-1 text-sm text-gray-500">
                    Use 1 for the first lesson, 2 for the second, and so on.
                </p>

                @error('lesson_order')
                    <p class="mt-1 text-sm text-red-600">
                        {{ $message }}
                    </p>
                @enderror

            </div>


            {{-- Publish --}}

            <div class="flex items-center gap-3">

                <input
                    type="checkbox"
                    id="is_published"
                    name="is_published"
                    value="1"
                    class="w-5 h-5 rounded border-gray-300
                           text-blue-600 focus:ring-blue-500"
                    @checked(old('is_published'))
                >

                <div>

                    <label
                        for="is_published"
                        class="font-semibold text-gray-700"
                    >
                        Publish this lesson
                    </label>

                    <p class="text-sm text-gray-500">
                        Published lessons can be made available to users.
                    </p>

                </div>

            </div>


            {{-- Actions --}}

            <div class="flex flex-wrap gap-3 pt-4 border-t">

                <x-admin.button type="primary">
                    Create Lesson
                </x-admin.button>

                <a
                    href="{{ route('admin.lessons.index') }}"
                    class="px-5 py-2 rounded-lg font-medium
                           bg-gray-200 hover:bg-gray-300
                           text-gray-700"
                >
                    Cancel
                </a>

            </div>

        </form>

    </x-admin.card>

</div>

@endsection