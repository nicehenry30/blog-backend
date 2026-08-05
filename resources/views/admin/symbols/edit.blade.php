@extends('layouts.app')

@section('title', 'Edit Trading Symbol')

@section('content')

<form
    method="POST"
    action="{{ route('admin.symbols.update', $symbol) }}">

    @csrf
    @method('PUT')

    <div class="space-y-8">

        <!-- Header -->

        <div class="flex items-center justify-between">

            <div>

                <h1 class="text-3xl font-bold">
                    Edit Trading Symbol
                </h1>

                <p class="text-gray-500 mt-1">
                    Update trading symbol information.
                </p>

            </div>

            <a
                href="{{ route('admin.symbols.index') }}"
                class="px-5 py-3 border rounded-lg hover:bg-gray-100">

                ← Back

            </a>

        </div>

        <!-- Form -->

        <div class="bg-white rounded-xl shadow p-6">

            @include('admin.symbols._form')

        </div>

        <!-- Buttons -->

        <div class="flex justify-end gap-4">

            <a
                href="{{ route('admin.symbols.index') }}"
                class="px-6 py-3 border rounded-lg">

                Cancel

            </a>

            <button
                type="submit"
                class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg">

                Update Symbol

            </button>

        </div>

    </div>

</form>

@endsection