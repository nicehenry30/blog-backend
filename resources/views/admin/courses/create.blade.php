@extends('layouts.app')

@section('title', 'Create Course')

@section('content')

<div class="max-w-4xl mx-auto space-y-6">

    {{-- Page Header --}}

    <div>

        <h1 class="text-3xl font-bold text-gray-900">
            Create Course
        </h1>

        <p class="mt-2 text-gray-500">
            Create a new educational course for Tradewisser users.
        </p>

    </div>


    {{-- Form --}}

    <x-admin.card title="Course Information">

        <form
            method="POST"
            action="{{ route('admin.courses.store') }}"
            class="space-y-6"
        >

            @csrf


            {{-- Title --}}

            <div>

                <label
                    for="title"
                    class="block text-sm font-semibold text-gray-700 mb-2"
                >
                    Course Title
                </label>

                <input
                    type="text"
                    id="title"
                    name="title"
                    value="{{ old('title') }}"
                    placeholder="e.g. Forex Trading for Beginners"
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
                    Description
                </label>

                <textarea
                    id="description"
                    name="description"
                    rows="5"
                    placeholder="Briefly describe what traders will learn in this course..."
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


            {{-- Category + Level --}}

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">


                {{-- Category --}}

                <div>

                    <label
                        for="category"
                        class="block text-sm font-semibold text-gray-700 mb-2"
                    >
                        Category
                    </label>

                    <input
                        type="text"
                        id="category"
                        name="category"
                        value="{{ old('category') }}"
                        placeholder="e.g. Forex Basics"
                        class="w-full border border-gray-300 rounded-lg px-4 py-3
                               focus:ring-2 focus:ring-blue-500
                               focus:border-blue-500"
                    >

                    @error('category')
                        <p class="mt-1 text-sm text-red-600">
                            {{ $message }}
                        </p>
                    @enderror

                </div>


                {{-- Level --}}

                <div>

                    <label
                        for="level"
                        class="block text-sm font-semibold text-gray-700 mb-2"
                    >
                        Level
                    </label>

                    <select
                        id="level"
                        name="level"
                        class="w-full border border-gray-300 rounded-lg px-4 py-3
                               focus:ring-2 focus:ring-blue-500
                               focus:border-blue-500"
                        required
                    >

                        <option
                            value="beginner"
                            @selected(old('level', 'beginner') === 'beginner')
                        >
                            Beginner
                        </option>

                        <option
                            value="intermediate"
                            @selected(old('level') === 'intermediate')
                        >
                            Intermediate
                        </option>

                        <option
                            value="advanced"
                            @selected(old('level') === 'advanced')
                        >
                            Advanced
                        </option>

                    </select>

                    @error('level')
                        <p class="mt-1 text-sm text-red-600">
                            {{ $message }}
                        </p>
                    @enderror

                </div>

            </div>


            {{-- Thumbnail --}}

            <div>

                <label
                    for="thumbnail"
                    class="block text-sm font-semibold text-gray-700 mb-2"
                >
                    Thumbnail URL
                </label>

                <input
                    type="text"
                    id="thumbnail"
                    name="thumbnail"
                    value="{{ old('thumbnail') }}"
                    placeholder="https://example.com/course-image.jpg"
                    class="w-full border border-gray-300 rounded-lg px-4 py-3
                           focus:ring-2 focus:ring-blue-500
                           focus:border-blue-500"
                >

                <p class="mt-1 text-sm text-gray-500">
                    You can leave this empty for now.
                </p>

                @error('thumbnail')
                    <p class="mt-1 text-sm text-red-600">
                        {{ $message }}
                    </p>
                @enderror

            </div>


            {{-- Sort Order --}}

            <div>

                <label
                    for="sort_order"
                    class="block text-sm font-semibold text-gray-700 mb-2"
                >
                    Display Order
                </label>

                <input
                    type="number"
                    id="sort_order"
                    name="sort_order"
                    value="{{ old('sort_order', 0) }}"
                    min="0"
                    class="w-full border border-gray-300 rounded-lg px-4 py-3
                           focus:ring-2 focus:ring-blue-500
                           focus:border-blue-500"
                >

                <p class="mt-1 text-sm text-gray-500">
                    Lower numbers appear first.
                </p>

                @error('sort_order')
                    <p class="mt-1 text-sm text-red-600">
                        {{ $message }}
                    </p>
                @enderror

            </div>


            {{-- Published --}}

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
                        Publish this course
                    </label>

                    <p class="text-sm text-gray-500">
                        Published courses can be displayed to users.
                    </p>

                </div>

            </div>


            {{-- Actions --}}

            <div class="flex flex-wrap gap-3 pt-4 border-t">

                <x-admin.button type="primary">
                    Create Course
                </x-admin.button>

                <a
                    href="{{ route('admin.courses.index') }}"
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