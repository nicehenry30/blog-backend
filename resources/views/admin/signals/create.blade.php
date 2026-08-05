@extends('layouts.app')

@section('title', 'Create Trading Signal')

@section('content')

<form method="POST"
      action="{{ route('admin.signals.store') }}"
      enctype="multipart/form-data">

    @csrf

    <div class="space-y-8">

        <div class="flex items-center justify-between">

            <div>

                <h1 class="text-3xl font-bold">
                    Create Trading Signal
                </h1>

                <p class="text-gray-500 mt-1">
                    Publish a new trading signal for Tradewisser users.
                </p>

            </div>

            <a href="{{ route('admin.signals.index') }}"
               class="px-5 py-3 border rounded-lg hover:bg-gray-100">

                ← Back

            </a>

        </div>

        @include('admin.signals._form')

        <div class="flex justify-end gap-4">

            <button
                type="submit"
                name="action"
                value="Draft"
                class="bg-yellow-500 hover:bg-yellow-600 text-white px-6 py-3 rounded-lg">

                Save Draft

            </button>

            <button
                type="submit"
                name="action"
                value="Published"
                class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg">

                Publish Signal

            </button>

        </div>

    </div>

</form>

@endsection