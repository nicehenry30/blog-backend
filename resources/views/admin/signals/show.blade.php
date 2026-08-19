@extends('layouts.app')

@section('title', 'Signal Details')

@section('content')

<div class="space-y-6">

    {{-- ===================================================== --}}
    {{-- Header --}}
    {{-- ===================================================== --}}

    <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6">

        <div>

            <a
                href="{{ route('admin.signals.index') }}"
                class="text-blue-600 hover:underline"
            >
                ← Back to Signals
            </a>

            <h1 class="mt-3 text-3xl font-bold flex items-center gap-3">

                {{ $signal->symbol?->symbol }}

                <x-signal.direction
                    :direction="$signal->direction"
                />

            </h1>

            <div class="mt-4 flex flex-wrap gap-3">

                <x-signal.badge
                    :status="$signal->status"
                />

                <x-signal.visibility-badge
                    :visibility="$signal->visibility"
                />

            </div>

        </div>

        <div class="flex flex-wrap gap-3">

            <a
                href="{{ route('admin.signals.edit', $signal) }}"
            >
                <x-admin.button type="secondary">
                    Edit
                </x-admin.button>
            </a>

            <x-signal.workflow-button
                :signal="$signal"
            />

        </div>

    </div>

    {{-- ===================================================== --}}
    {{-- Signal Information + Chart --}}
    {{-- ===================================================== --}}

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

        {{-- Signal Information --}}

        <x-admin.card title="Signal Information">

            <div class="space-y-5">

                <div class="flex justify-between">

                    <span class="text-gray-500">
                        Entry
                    </span>

                    <strong>
                        {{ number_format($signal->entry_price, 5) }}
                    </strong>

                </div>

                <div class="flex justify-between">

                    <span class="text-gray-500">
                        Stop Loss
                    </span>

                    <strong>
                        {{ number_format($signal->stop_loss, 5) }}
                    </strong>

                </div>

                <div class="flex justify-between">

                    <span class="text-gray-500">
                        Timeframe
                    </span>

                    <strong>
                        {{ $signal->timeframe }}
                    </strong>

                </div>
                <div class="flex justify-between">

    <span class="text-gray-500">
        Visibility
    </span>

    <x-signal.visibility-badge
        :visibility="$signal->visibility"
    />

</div>

    <div class="flex justify-between">

        <span class="text-gray-500">
            Direction
        </span>

        <x-signal.direction
            :direction="$signal->direction"
        />

    </div>

                <div class="flex justify-between">

                    <span class="text-gray-500">
                        Risk / Reward
                    </span>

                    <strong>
                        {{ $signal->risk_reward }}
                    </strong>

                </div>

                <div class="flex justify-between">

                    <span class="text-gray-500">
                        Signal Quality
                    </span>

                    <strong class="text-blue-600">
                        {{ $signal->signal_quality }}%
                    </strong>

                </div>

            </div>

        </x-admin.card>

        {{-- Chart --}}

        <div class="lg:col-span-2">

            <x-admin.card title="Chart">

                @if($signal->chart_image)

                    <img
                        src="{{ asset('storage/' . $signal->chart_image) }}"
                        alt="Signal Chart"
                        class="w-full rounded-xl border"
                    >

                @else

                    <div
                        class="h-96 flex items-center justify-center rounded-xl border-2 border-dashed border-gray-300 text-gray-400"
                    >

                        No Chart Uploaded

                    </div>

                @endif

            </x-admin.card>

        </div>

    </div>
        {{-- ===================================================== --}}
    {{-- Take Profit Targets + AI Analysis --}}
    {{-- ===================================================== --}}

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">

        {{-- Take Profit Targets --}}

        <x-admin.card title="Take Profit Targets">

            <div class="space-y-5">

                <div class="flex justify-between">

                    <span class="text-gray-500">
                        TP1
                    </span>

                    <strong>
                        {{ number_format($signal->take_profit, 5) }}
                    </strong>

                </div>

                @if($signal->take_profit_2)

                    <div class="flex justify-between">

                        <span class="text-gray-500">
                            TP2
                        </span>

                        <strong>
                            {{ number_format($signal->take_profit_2, 5) }}
                        </strong>

                    </div>

                @endif

                @if($signal->take_profit_3)

                    <div class="flex justify-between">

                        <span class="text-gray-500">
                            TP3
                        </span>

                        <strong>
                            {{ number_format($signal->take_profit_3, 5) }}
                        </strong>

                    </div>

                @endif

            </div>

        </x-admin.card>

        {{-- AI Analysis --}}

        <x-admin.card title="AI Analysis">

            <div class="space-y-6">

                <div>

                    <div class="text-sm text-gray-500">
                        AI Confidence
                    </div>

                    <div class="mt-2 text-4xl font-bold text-blue-600">

                        {{ $signal->overall_confidence ?? '--' }}%

                    </div>

                </div>

                <div>

                    <div class="text-sm text-gray-500 mb-2">
                        AI Comment
                    </div>

                    <p class="leading-7 text-gray-700">

                        {{ $signal->ai_comment ?: 'No AI analysis available.' }}

                    </p>

                </div>

            </div>

        </x-admin.card>

    </div>

    {{-- ===================================================== --}}
    {{-- Strategy + Confluences --}}
    {{-- ===================================================== --}}

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">

        {{-- Strategy --}}

        <x-admin.card title="Trading Strategy">

            <div class="space-y-6">

                <div>

                    <div class="text-sm text-gray-500">
                        Strategy
                    </div>

                    <div class="mt-2 font-semibold">

                        {{ $signal->strategy }}

                    </div>

                </div>

                <div>

                    <div class="text-sm text-gray-500">
                        Analysis
                    </div>

                    <div class="mt-2 leading-7 text-gray-700">

                        {{ $signal->analysis ?: 'No analysis provided.' }}

                    </div>

                </div>

            </div>

        </x-admin.card>

        {{-- Confluences --}}

        <x-admin.card title="Confluences">

            @if(!empty($signal->confluences))

                <div class="flex flex-wrap gap-3">

                    @foreach($signal->confluences as $item)

                        <span
                            class="px-4 py-2 rounded-full bg-indigo-100 text-indigo-700 text-sm font-medium"
                        >

                            {{ $item }}

                        </span>

                    @endforeach

                </div>

            @else

                <div class="py-8 text-center text-gray-500">

                    No confluences available.

                </div>

            @endif

        </x-admin.card>

    </div>
        {{-- ===================================================== --}}
    {{-- Signal Metadata --}}
    {{-- ===================================================== --}}

    <x-admin.card title="Signal Information">

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6">

            <div>

                <div class="text-sm text-gray-500">
                    Created By
                </div>

                <div class="mt-2 font-semibold">
                    {{ $signal->creator?->name ?? '--' }}
                </div>

            </div>

            <div>

                <div class="text-sm text-gray-500">
                    Approved By
                </div>

                <div class="mt-2 font-semibold">
                    {{ $signal->approver?->name ?? '--' }}
                </div>

            </div>

            <div>

                <div class="text-sm text-gray-500">
                    Published
                </div>

                <div class="mt-2 font-semibold">
                    {{ $signal->published_at?->format('d M Y H:i') ?? '--' }}
                </div>

            </div>

            <div>

                <div class="text-sm text-gray-500">
                    Closed
                </div>
                <div>

                <div class="text-sm text-gray-500">
                    Visibility
                </div>

                <div class="mt-2">

                    <x-signal.visibility-badge
                        :visibility="$signal->visibility"
                    />

                </div>

            </div>

                <div class="mt-2 font-semibold">
                    {{ $signal->closed_at?->format('d M Y H:i') ?? '--' }}
                </div>

            </div>

        </div>

    </x-admin.card>

    {{-- ===================================================== --}}
    {{-- Workflow Timeline --}}
    {{-- ===================================================== --}}

    @php

        use App\Models\Signal;

        $steps = Signal::statuses();

        $currentIndex = array_search(
            $signal->status,
            $steps,
            true
        );

    @endphp

    <x-admin.card title="Workflow Timeline">

        <div class="space-y-4">

            @foreach($steps as $index => $step)

                <div class="flex items-center gap-4">

                    @if($currentIndex !== false && $index <= $currentIndex)

                        <div
                            class="w-8 h-8 rounded-full bg-green-600 text-white flex items-center justify-center"
                        >
                            ✓
                        </div>

                    @else

                        <div
                            class="w-8 h-8 rounded-full bg-gray-300"
                        >
                        </div>

                    @endif

                    <div class="font-medium">

                        {{ $step }}

                    </div>

                </div>

            @endforeach

        </div>

    </x-admin.card>

    {{-- ===================================================== --}}
    {{-- Signal History --}}
    {{-- ===================================================== --}}

    <x-admin.card title="Signal History">

        @if($signal->histories->isNotEmpty())

            <div class="overflow-x-auto">

                <table class="min-w-full">

                    <thead class="border-b bg-gray-50">

                        <tr>

                            <th class="px-4 py-3 text-left">
                                Date
                            </th>

                            <th class="px-4 py-3 text-left">
                                User
                            </th>

                            <th class="px-4 py-3 text-left">
                                Event
                            </th>

                            <th class="px-4 py-3 text-left">
                                Status
                            </th>

                            <th class="px-4 py-3 text-left">
                                Description
                            </th>

                        </tr>

                    </thead>

                    <tbody>

                        @foreach($signal->histories as $history)

                            <tr class="border-b">

                                <td class="px-4 py-4">
                                    {{ $history->created_at->format('d M Y H:i') }}
                                </td>

                                <td class="px-4 py-4">
                                    {{ $history->user?->name ?? '--' }}
                                </td>

                                <td class="px-4 py-4">
                                    {{ ucfirst($history->event) }}
                                </td>

                                <td class="px-4 py-4">

                                    {{ $history->old_status ?? '--' }}

                                    →

                                    {{ $history->new_status }}

                                </td>

                                <td class="px-4 py-4">
                                    {{ $history->description }}
                                </td>

                            </tr>

                        @endforeach

                    </tbody>

                </table>

            </div>

        @else

            <div class="py-12 text-center text-gray-500">

                No workflow history recorded yet.

            </div>

        @endif

    </x-admin.card>

</div>

@endsection