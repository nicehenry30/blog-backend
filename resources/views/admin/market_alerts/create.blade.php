@extends('layouts.app')

@section('title', 'Create Market Alert')

@section('content')

<div class="max-w-4xl mx-auto space-y-6">

    {{-- Page Header --}}

    <div>

        <h1 class="text-3xl font-bold text-gray-900">
            Create Market Alert
        </h1>

        <p class="mt-2 text-gray-500">
            Publish a warning to traders about important market events.
        </p>

    </div>


    {{-- Form --}}

    <x-admin.card>

        <form
            method="POST"
            action="{{ route('admin.market-alerts.store') }}"
            class="space-y-6"
        >

            @csrf


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
                    value="{{ old('title') }}"
                    placeholder="e.g. US CPI"
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


            {{-- Currency --}}

            {{-- Currency / Market --}}

                {{-- Currency / Market --}}

                <div>

                    <label
                        for="symbol"
                        class="block text-sm font-semibold text-gray-700 mb-2"
                    >
                        Market Symbol
                    </label>

                    <input
                        type="text"
                        id="symbol"
                        name="symbol"
                        value="{{ old('symbol') }}"
                        list="market-symbols"
                        placeholder="e.g. USD, XAUUSD, US30, BTCUSD"
                        maxlength="20"
                        class="w-full border rounded-lg px-4 py-3
                            focus:ring-2 focus:ring-blue-500
                            focus:border-blue-500"
                        required
                    >

                    <datalist id="market-symbols">

                        <option value="USD">
                        <option value="EUR">
                        <option value="GBP">
                        <option value="JPY">
                        <option value="AUD">
                        <option value="CAD">
                        <option value="CHF">
                        <option value="NZD">

                        <option value="XAUUSD">
                        <option value="XAGUSD">

                        <option value="US30">
                        <option value="NAS100">
                        <option value="SPX500">
                        <option value="GER40">
                        <option value="UK100">

                        <option value="BTCUSD">
                        <option value="ETHUSD">

                        <option value="USOIL">
                        <option value="UKOIL">

                    </datalist>

                    <p class="mt-1 text-sm text-gray-500">
                        Select a common symbol or enter a custom market symbol.
                    </p>

                    @error('symbol')
                        <p class="mt-1 text-sm text-red-600">
                            {{ $message }}
                        </p>
                    @enderror

                </div>

            {{-- Impact --}}

            <div>

                <label class="block text-sm font-semibold text-gray-700 mb-3">
                    Impact Level
                </label>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">


                    {{-- Low --}}

                    <label class="cursor-pointer">

                        <input
                            type="radio"
                            name="impact"
                            value="low"
                            class="sr-only peer"
                            @checked(old('impact') === 'low')
                            required
                        >

                        <div class="border-2 border-gray-200 rounded-xl p-4
                                    peer-checked:border-green-500
                                    peer-checked:bg-green-50
                                    transition">

                            <div class="text-2xl">
                                🟢
                            </div>

                            <div class="font-semibold text-green-700 mt-2">
                                Low Impact
                            </div>

                            <div class="text-sm text-gray-500 mt-1">
                                Limited expected volatility
                            </div>

                        </div>

                    </label>


                    {{-- Medium --}}

                    <label class="cursor-pointer">

                        <input
                            type="radio"
                            name="impact"
                            value="medium"
                            class="sr-only peer"
                            @checked(old('impact') === 'medium')
                        >

                        <div class="border-2 border-gray-200 rounded-xl p-4
                                    peer-checked:border-yellow-500
                                    peer-checked:bg-yellow-50
                                    transition">

                            <div class="text-2xl">
                                🟡
                            </div>

                            <div class="font-semibold text-yellow-700 mt-2">
                                Medium Impact
                            </div>

                            <div class="text-sm text-gray-500 mt-1">
                                Moderate volatility possible
                            </div>

                        </div>

                    </label>


                    {{-- High --}}

                    <label class="cursor-pointer">

                        <input
                            type="radio"
                            name="impact"
                            value="high"
                            class="sr-only peer"
                            @checked(old('impact') === 'high')
                        >

                        <div class="border-2 border-gray-200 rounded-xl p-4
                                    peer-checked:border-red-500
                                    peer-checked:bg-red-50
                                    transition">

                            <div class="text-2xl">
                                🔴
                            </div>

                            <div class="font-semibold text-red-700 mt-2">
                                High Impact
                            </div>

                            <div class="text-sm text-gray-500 mt-1">
                                Significant volatility expected
                            </div>

                        </div>

                    </label>

                </div>

                @error('impact')
                    <p class="mt-2 text-sm text-red-600">
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
                    Alert Date & Time
                </label>

                <input
                    type="datetime-local"
                    id="alert_time"
                    name="alert_time"
                    value="{{ old('alert_time') }}"
                    class="w-full border rounded-lg px-4 py-3
                           focus:ring-2 focus:ring-blue-500"
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
                    Trader Recommendation
                </label>

                <textarea
                    id="recommendation"
                    name="recommendation"
                    rows="5"
                    placeholder="Example: Avoid opening new USD positions 30 minutes before and after the release."
                    class="w-full border rounded-lg px-4 py-3
                           focus:ring-2 focus:ring-blue-500"
                    required
                >{{ old('recommendation') }}</textarea>

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
                    @checked(old('is_active', true))
                >

                <label
                    for="is_active"
                    class="font-medium text-gray-700"
                >
                    Publish this alert immediately
                </label>

            </div>


            {{-- Actions --}}

            <div class="flex flex-wrap gap-3 pt-4 border-t">

                <x-admin.button type="primary">
                    Publish Market Alert
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