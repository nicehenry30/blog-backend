@extends('layouts.app')

@section('title', 'Edit Market Alert')

@section('content')

<div class="max-w-4xl mx-auto space-y-6">

    {{-- Page Header --}}
    <div>
        <h1 class="text-3xl font-bold text-gray-900">
            Edit Market Alert
        </h1>

        <p class="mt-2 text-gray-500">
            Update this market alert.
        </p>
    </div>


    {{-- Form --}}
    <x-admin.card>

        <form
            method="POST"
            action="{{ route('admin.market-alerts.update', $marketAlert) }}"
            class="space-y-6"
        >

            @csrf
            @method('PUT')


            {{-- Title --}}
            <div>
                <label
                    for="title"
                    class="block text-sm font-semibold text-gray-700 mb-2"
                >
                    Alert Title
                </label>

                <input
                    type="text"
                    id="title"
                    name="title"
                    value="{{ old('title', $marketAlert->title) }}"
                    class="w-full border rounded-lg px-4 py-3
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


            {{-- Symbol --}}
            <div>
                <label
                    for="symbol"
                    class="block text-sm font-semibold text-gray-700 mb-2"
                >
                    Currency / Market Symbol
                </label>

                <input
                    type="text"
                    id="symbol"
                    name="symbol"
                    value="{{ old('symbol', $marketAlert->symbol) }}"
                    class="w-full border rounded-lg px-4 py-3
                           focus:ring-2 focus:ring-blue-500
                           focus:border-blue-500"
                    required
                >

                @error('symbol')
                    <p class="mt-1 text-sm text-red-600">
                        {{ $message }}
                    </p>
                @enderror
            </div>


            {{-- Impact --}}
            <div>
                <label
                    for="impact"
                    class="block text-sm font-semibold text-gray-700 mb-2"
                >
                    Impact
                </label>

                <select
                    id="impact"
                    name="impact"
                    class="w-full border rounded-lg px-4 py-3
                           focus:ring-2 focus:ring-blue-500
                           focus:border-blue-500"
                    required
                >

                    <option value="low"
                        @selected(old('impact', $marketAlert->impact) === 'low')>
                        Low
                    </option>

                    <option value="medium"
                        @selected(old('impact', $marketAlert->impact) === 'medium')>
                        Medium
                    </option>

                    <option value="high"
                        @selected(old('impact', $marketAlert->impact) === 'high')>
                        High
                    </option>

                </select>

                @error('impact')
                    <p class="mt-1 text-sm text-red-600">
                        {{ $message }}
                    </p>
                @enderror
            </div>


            {{-- Alert Time --}}
            <div>
                <label
                    for="alert_time"
                    class="block text-sm font-semibold text-gray-700 mb-2"
                >
                    Alert Time
                </label>

                <input
                    type="datetime-local"
                    id="alert_time"
                    name="alert_time"
                    value="{{ old('alert_time', $marketAlert->alert_time?->format('Y-m-d\TH:i')) }}"
                    class="w-full border rounded-lg px-4 py-3
                           focus:ring-2 focus:ring-blue-500
                           focus:border-blue-500"
                    required
                >

                @error('alert_time')
                    <p class="mt-1 text-sm text-red-600">
                        {{ $message }}
                    </p>
                @enderror
            </div>


            {{-- Recommendation --}}
            <div>
                <label
                    for="recommendation"
                    class="block text-sm font-semibold text-gray-700 mb-2"
                >
                    Recommendation
                </label>

                <textarea
                    id="recommendation"
                    name="recommendation"
                    rows="6"
                    class="w-full border rounded-lg px-4 py-3
                           focus:ring-2 focus:ring-blue-500
                           focus:border-blue-500"
                    required
                >{{ old('recommendation', $marketAlert->recommendation) }}</textarea>

                @error('recommendation')
                    <p class="mt-1 text-sm text-red-600">
                        {{ $message }}
                    </p>
                @enderror
            </div>


            {{-- Active --}}
            <div class="flex items-center gap-3">

                <input
                    type="checkbox"
                    id="is_active"
                    name="is_active"
                    value="1"
                    class="w-5 h-5 rounded border-gray-300
                           text-blue-600 focus:ring-blue-500"
                    @checked(old('is_active', $marketAlert->is_active))
                >

                <label
                    for="is_active"
                    class="font-medium text-gray-700"
                >
                    Keep this alert active
                </label>

            </div>


            {{-- Actions --}}
            <div class="flex flex-wrap gap-3 pt-4 border-t">

                <x-admin.button type="primary">
                    Update Market Alert
                </x-admin.button>

                <a
                    href="{{ route('admin.market-alerts.index') }}"
                    class="px-5 py-2 rounded-lg font-medium
                           bg-gray-200 hover:bg-gray-300"
                >
                    Cancel
                </a>

            </div>

        </form>

    </x-admin.card>

</div>

@endsection