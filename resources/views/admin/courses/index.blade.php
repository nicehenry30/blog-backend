@extends('layouts.app')

@section('title', 'Courses')

@section('content')

{{-- ========================================================= --}}
{{-- Page Header --}}
{{-- ========================================================= --}}

<div class="flex flex-col md:flex-row md:items-center md:justify-between gap-6">

    <div>

        <h1 class="text-3xl font-bold text-gray-900">
            Education Courses
        </h1>

        <p class="mt-2 text-gray-500">
            Manage trading courses and educational content.
        </p>

    </div>

    <a href="{{ route('admin.courses.create') }}">

        <x-admin.button>
            + Create Course
        </x-admin.button>

    </a>

</div>


{{-- ========================================================= --}}
{{-- Course Statistics --}}
{{-- ========================================================= --}}

<div class="grid grid-cols-1 md:grid-cols-3 gap-6">

    <x-admin.stat-card
        title="Total Courses"
        :value="$totalCourses"
        color="gray"
    />

    <x-admin.stat-card
        title="Published"
        :value="$publishedCourses"
        color="green"
    />

    <x-admin.stat-card
        title="Drafts"
        :value="$draftCourses"
        color="yellow"
    />

</div>


{{-- ========================================================= --}}
{{-- Courses Table --}}
{{-- ========================================================= --}}

<x-admin.card title="All Courses">

    <div class="overflow-x-auto">

        <table class="min-w-full">

            <thead class="bg-gray-50 border-b">

                <tr>

                    <th class="px-6 py-4 text-left">
                        Course
                    </th>

                    <th class="px-6 py-4 text-left">
                        Category
                    </th>

                    <th class="px-6 py-4 text-left">
                        Level
                    </th>

                    <th class="px-6 py-4 text-left">
                        Status
                    </th>

                    <th class="px-6 py-4 text-center">
                        Order
                    </th>

                    <th class="px-6 py-4 text-center">
                        Actions
                    </th>

                </tr>

            </thead>


            <tbody>

                @forelse($courses as $course)

                    <tr class="border-b hover:bg-gray-50 transition">

                        {{-- Course --}}

                        <td class="px-6 py-5">

                            <div class="font-semibold text-gray-900">

                                <a
                                    href="{{ route('admin.courses.show', $course) }}"
                                    class="text-blue-600 hover:text-blue-800 hover:underline"
                                >
                                    {{ $course->title }}
                                </a>

                            </div>

                            @if($course->description)

                                <div class="text-sm text-gray-500 mt-1">

                                    {{ Str::limit(
                                        $course->description,
                                        70
                                    ) }}

                                </div>

                            @endif

                        </td>


                        {{-- Category --}}

                        <td class="px-6 py-5">

                            @if($course->category)

                                <span class="font-medium">
                                    {{ $course->category }}
                                </span>

                            @else

                                <span class="text-gray-400">
                                    —
                                </span>

                            @endif

                        </td>


                        {{-- Level --}}

                        <td class="px-6 py-5">

                            @if($course->level === 'advanced')

                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-red-100 text-red-700">
                                    Advanced
                                </span>

                            @elseif($course->level === 'intermediate')

                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-yellow-100 text-yellow-700">
                                    Intermediate
                                </span>

                            @else

                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-green-100 text-green-700">
                                    Beginner
                                </span>

                            @endif

                        </td>


                        {{-- Status --}}

                        <td class="px-6 py-5">

                            @if($course->is_published)

                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-green-100 text-green-700">
                                    ● Published
                                </span>

                            @else

                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-gray-100 text-gray-600">
                                    ● Draft
                                </span>

                            @endif

                        </td>


                        {{-- Sort Order --}}

                        <td class="px-6 py-5 text-center">

                            <span class="font-semibold">
                                {{ $course->sort_order }}
                            </span>

                        </td>


                        {{-- Actions --}}

                        <td class="px-6 py-5">

                            <div class="flex flex-wrap gap-2 justify-center">

                                {{-- View --}}

                                <a
                                    href="{{ route('admin.courses.show', $course) }}"
                                >

                                    <x-admin.button type="primary">
                                        View
                                    </x-admin.button>

                                </a>


                                {{-- Edit --}}

                                <a
                                    href="{{ route('admin.courses.edit', $course) }}"
                                >

                                    <x-admin.button type="secondary">
                                        Edit
                                    </x-admin.button>

                                </a>


                                {{-- Delete --}}

                                <form
                                    method="POST"
                                    action="{{ route('admin.courses.destroy', $course) }}"
                                    onsubmit="return confirm('Delete this course?')"
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

                            No courses found.

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

    {{ $courses->links() }}

</div>

@endsection