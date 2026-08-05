@extends('layouts.app')

@section('title', 'Edit Trading Signal')

@section('content')

<form method="POST"
      action="{{ route('admin.signals.update', $signal) }}"
      enctype="multipart/form-data">

    @csrf
    @method('PUT')

    <div class="space-y-8">

        <div class="flex items-center justify-between">

            <div>

                <h1 class="text-3xl font-bold">
                    Edit Trading Signal
                </h1>

                <p class="text-gray-500 mt-1">
                    Update this trading signal.
                </p>

            </div>

            <a href="{{ route('admin.signals.index') }}"
               class="px-5 py-3 border rounded-lg hover:bg-gray-100">

                ← Back

            </a>

        </div>

        @include('admin.signals._form')

        <div class="flex justify-end gap-4">

            <a href="{{ route('admin.signals.index') }}"
               class="px-6 py-3 border rounded-lg hover:bg-gray-100">

                Cancel

            </a>

            <button
                type="submit"
                class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg">

                Update Signal

            </button>

        </div>

    </div>

</form>

@endsection