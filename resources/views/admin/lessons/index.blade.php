@extends('layouts.app')

@section('title', 'Lessons')

@section('content')

{{-- ========================================================= --}}
{{-- Page Header --}}
{{-- ========================================================= --}}

<div class="flex flex-col md:flex-row md:items-center md:justify-between gap-6">

    <div>

        <h1 class="text-3xl font-bold text-gray-900">
            Video Lessons
        </h1>

        <p class="mt-2 text-gray-500">
            Manage course lessons and video tutorials.
        </p>

    </div>

    <a href="{{ route('admin.lessons.create') }}">

        <x-admin.button>
            + Create Lesson
        </x-admin.button>

    </a>

</div>


{{-- ========================================================= --}}
{{-- Lessons Table --}}
{{-- ========================================================= --}}

<x-admin.card title="All Lessons">

    <div class="overflow-x-auto">

        <table class="min-w-full">

            <thead class="bg-gray-50 border-b">

                <tr>

                    <th class="px-6 py-4 text-left">
                        Lesson
                    </th>

                    <th class="px-6 py-4 text-left">
                        Course
                    </th>

                    <th class="px-6 py-4 text-center">
                        Order
                    </th>

                    <th class="px-6 py-4 text-center">
                        Video
                    </th>

                    <th class="px-6 py-4 text-left">
                        Status
                    </th>

                    <th class="px-6 py-4 text-center">
                        Actions
                    </th>

                </tr>

            </thead>


            <tbody>

                @forelse($lessons as $lesson)

                    <tr class="border-b hover:bg-gray-50 transition">

                        {{-- Lesson --}}

                        <td class="px-6 py-5">

                            <div class="font-semibold">

                                <a
                                    href="{{ route('admin.lessons.show', $lesson) }}"
                                    class="text-blue-600 hover:text-blue-800 hover:underline"
                                >
                                    {{ $lesson->title }}
                                </a>

                            </div>

                            @if($lesson->description)

                                <div class="text-sm text-gray-500 mt-1">

                                    {{ Str::limit(
                                        $lesson->description,
                                        70
                                    ) }}

                                </div>

                            @endif

                        </td>


                        {{-- Course --}}

                        <td class="px-6 py-5">

                            @if($lesson->course)

                                <span class="font-medium">
                                    {{ $lesson->course->title }}
                                </span>

                            @else

                                <span class="text-red-500">
                                    Course unavailable
                                </span>

                            @endif

                        </td>


                        {{-- Order --}}

                        <td class="px-6 py-5 text-center">

                            <span class="font-semibold">
                                {{ $lesson->lesson_order }}
                            </span>

                        </td>


                        {{-- Video --}}

                        <td class="px-6 py-5 text-center">

                            @if($lesson->video_url)

                                <a
                                    href="{{ $lesson->video_url }}"
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    class="inline-flex items-center px-3 py-1 rounded-full
                                           text-sm font-semibold bg-blue-100 text-blue-700
                                           hover:bg-blue-200"
                                >
                                    ▶ Watch
                                </a>

                            @else

                                <span class="text-gray-400">
                                    No video
                                </span>

                            @endif

                        </td>


                        {{-- Status --}}

                        <td class="px-6 py-5">

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

                        </td>


                        {{-- Actions --}}

                        <td class="px-6 py-5">

                            <div class="flex flex-wrap gap-2 justify-center">

                                {{-- View --}}

                                <a
                                    href="{{ route('admin.lessons.show', $lesson) }}"
                                >

                                    <x-admin.button type="primary">
                                        View
                                    </x-admin.button>

                                </a>


                                {{-- Edit --}}

                                <a
                                    href="{{ route('admin.lessons.edit', $lesson) }}"
                                >

                                    <x-admin.button type="secondary">
                                        Edit
                                    </x-admin.button>

                                </a>


                                {{-- Delete --}}

                                <form
                                    method="POST"
                                    action="{{ route('admin.lessons.destroy', $lesson) }}"
                                    onsubmit="return confirm('Delete this lesson?')"
                                >

                                    @csrf

                                    @method('DELETE')

                                    <x-admin.button type="danger">
                                        Delete
                                    </x-admin.button>

                                </form>

                            </div>

                        </td>

                    </tr>

                @empty

                    <tr>

                        <td
                            colspan="6"
                            class="py-16 text-center text-gray-500"
                        >

                            No lessons found.

                        </td>

                    </tr>

                @endforelse

            </tbody>

        </table>

    </div>

</x-admin.card>


{{-- ========================================================= --}}
{{-- Pagination --}}
{{-- ========================================================= --}}

<div class="mt-6">

    {{ $lessons->links() }}

</div>

@endsection