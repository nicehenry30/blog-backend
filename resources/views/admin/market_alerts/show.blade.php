@extends('layouts.app')

@section('title', 'Market Alert')

@section('content')

<div class="max-w-4xl mx-auto space-y-6">

    {{-- Page Header --}}

    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">

        <div>
            <h1 class="text-3xl font-bold text-gray-900">
                Market Alert
            </h1>

            <p class="mt-2 text-gray-500">
                View market alert details.
            </p>
        </div>

        <div class="flex gap-3">

            <a
                href="{{ route('admin.market-alerts.edit', $marketAlert) }}"
            >
                <x-admin.button type="secondary">
                    Edit
                </x-admin.button>
            </a>

            <a
                href="{{ route('admin.market-alerts.index') }}"
            >
                <x-admin.button type="primary">
                    Back
                </x-admin.button>
            </a>

        </div>

    </div>


    {{-- Alert Card --}}

    <x-admin.card>

        <div class="space-y-6">

            {{-- Title --}}

            <div>
                <p class="text-sm text-gray-500">
                    Alert Title
                </p>

                <h2 class="text-2xl font-bold text-gray-900 mt-1">
                    {{ $marketAlert->title }}
                </h2>
            </div>


            {{-- Symbol + Impact --}}

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                <div>

                    <p class="text-sm text-gray-500">
                        Market Symbol
                    </p>

                    <p class="text-lg font-semibold mt-1">
                        {{ $marketAlert->symbol }}
                    </p>

                </div>


                <div>

                    <p class="text-sm text-gray-500">
                        Impact
                    </p>

                    <div class="mt-2">

                        @if($marketAlert->impact === 'high')

                            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-red-100 text-red-700">
                                🔴 High Impact
                            </span>

                        @elseif($marketAlert->impact === 'medium')

                            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-yellow-100 text-yellow-700">
                                🟡 Medium Impact
                            </span>

                        @else

                            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-green-100 text-green-700">
                                🟢 Low Impact
                            </span>

                        @endif

                    </div>

                </div>

            </div>


            {{-- Alert Time --}}

            <div>

                <p class="text-sm text-gray-500">
                    Alert Date & Time
                </p>

                <p class="text-lg font-semibold mt-1">
                    {{ $marketAlert->alert_time->format('d M Y, H:i') }}
                </p>

            </div>


            {{-- Status --}}

            <div>

                <p class="text-sm text-gray-500">
                    Status
                </p>

                <div class="mt-2">

                    @if($marketAlert->status === 'upcoming')

                        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-blue-100 text-blue-700">
                            Upcoming
                        </span>

                    @elseif($marketAlert->status === 'live')

                        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-red-100 text-red-700">
                            🔴 Live
                        </span>

                    @else

                        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-gray-100 text-gray-600">
                            Inactive
                        </span>

                    @endif

                </div>

            </div>


            {{-- Recommendation --}}

            <div>

                <p class="text-sm text-gray-500">
                    Trader Recommendation
                </p>

                <div class="mt-2 bg-gray-50 border rounded-xl p-5">

                    <p class="text-gray-800 leading-relaxed whitespace-pre-line">
                        {{ $marketAlert->recommendation }}
                    </p>

                </div>

            </div>


            {{-- Active Status --}}

            <div class="flex items-center justify-between border-t pt-5">

                <div>

                    <p class="font-semibold text-gray-900">
                        Alert Availability
                    </p>

                    <p class="text-sm text-gray-500">
                        Whether this alert is currently enabled.
                    </p>

                </div>

                @if($marketAlert->is_active)

                    <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-green-100 text-green-700">
                        Active
                    </span>

                @else

                    <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-gray-100 text-gray-600">
                        Inactive
                    </span>

                @endif

            </div>


            {{-- Delete --}}

            <div class="border-t pt-5">

                <form
                    method="POST"
                    action="{{ route('admin.market-alerts.destroy', $marketAlert) }}"
                    onsubmit="return confirm('Are you sure you want to delete this market alert?')"
                >

                    @csrf
                    @method('DELETE')

                    <x-admin.button type="danger">
                        Delete Alert
                    </x-admin.button>

                </form>

            </div>

        </div>

    </x-admin.card>

</div>

@endsection