@extends('layouts.app')

@section('title', 'Lesson Details')

@section('content')

<div class="max-w-5xl mx-auto space-y-6">

    {{-- Page Header --}}

    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">

        <div>

            <p class="text-sm text-gray-500 mb-1">
                {{ $lesson->course->title ?? 'Course unavailable' }}
            </p>

            <h1 class="text-3xl font-bold text-gray-900">
                {{ $lesson->title }}
            </h1>

        </div>

        <div class="flex gap-2">

            <a href="{{ route('admin.lessons.edit', $lesson) }}">

                <x-admin.button type="secondary">
                    Edit Lesson
                </x-admin.button>

            </a>

            <a href="{{ route('admin.lessons.index') }}">

                <x-admin.button>
                    Back to Lessons
                </x-admin.button>

            </a>

        </div>

    </div>


    {{-- Lesson Information --}}

    <x-admin.card title="Lesson Information">

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

            {{-- Course --}}

            <div>

                <p class="text-sm text-gray-500">
                    Course
                </p>

                <p class="mt-1 font-semibold text-gray-900">
                    {{ $lesson->course->title ?? 'Course unavailable' }}
                </p>

            </div>


            {{-- Lesson Order --}}

            <div>

                <p class="text-sm text-gray-500">
                    Lesson Order
                </p>

                <p class="mt-1 font-semibold text-gray-900">
                    {{ $lesson->lesson_order }}
                </p>

            </div>


            {{-- Status --}}

            <div>

                <p class="text-sm text-gray-500">
                    Status
                </p>

                <div class="mt-1">

                    @if($lesson->is_published)

                        <span class="inline-flex items-center px-3 py-1 rounded-full
                                     text-sm font-semibold bg-green-100 text-green-700">
                            ● Published
                        </span>

                    @else

                        <span class="inline-flex items-center px-3 py-1 rounded-full
                                     text-sm font-semibold bg-gray-100 text-gray-600">
                            ● Draft
                        </span>

                    @endif

                </div>

            </div>


            {{-- Video --}}

            <div>

                <p class="text-sm text-gray-500">
                    Video Tutorial
                </p>

                @if($lesson->video_url)

                    <a
                        href="{{ $lesson->video_url }}"
                        target="_blank"
                        rel="noopener noreferrer"
                        class="inline-flex items-center mt-1 text-blue-600
                               hover:text-blue-800 hover:underline"
                    >
                        ▶ Open Video
                    </a>

                @else

                    <p class="mt-1 text-gray-400">
                        No video added
                    </p>

                @endif

            </div>

        </div>

    </x-admin.card>


    {{-- Description --}}

    <x-admin.card title="Lesson Description">

        @if($lesson->description)

            <div class="text-gray-700 leading-7 whitespace-pre-line">
                {{ $lesson->description }}
            </div>

        @else

            <p class="text-gray-400">
                No description provided.
            </p>

        @endif

    </x-admin.card>


    {{-- Video Preview --}}

    @if($lesson->video_url)

        <x-admin.card title="Video Tutorial">

            <div class="bg-gray-900 rounded-xl p-8 text-center">

                <div class="text-white text-5xl mb-4">
                    ▶
                </div>

                <h2 class="text-xl font-semibold text-white">
                    {{ $lesson->title }}
                </h2>

                <p class="text-gray-300 mt-2">
                    Click below to open the lesson video.
                </p>

                <a
                    href="{{ $lesson->video_url }}"
                    target="_blank"
                    rel="noopener noreferrer"
                    class="inline-flex items-center mt-6 px-6 py-3
                           rounded-lg bg-blue-600 text-white font-semibold
                           hover:bg-blue-700"
                >
                    Watch Video
                </a>

            </div>

        </x-admin.card>

    @endif


    {{-- Delete --}}

    <div class="flex justify-end">

        <form
            method="POST"
            action="{{ route('admin.lessons.destroy', $lesson) }}"
            onsubmit="return confirm('Delete this lesson?')"
        >

            @csrf

            @method('DELETE')

            <x-admin.button type="danger">
                Delete Lesson
            </x-admin.button>

        </form>

    </div>

</div>

@endsection