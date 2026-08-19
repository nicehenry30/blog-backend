@extends('layouts.app')

@section('title', 'Trading Signals')

@section('content')

<div class="space-y-6">

    {{-- ========================================================= --}}
    {{-- Page Header --}}
    {{-- ========================================================= --}}

    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-6">

        <div>

            <h1 class="text-3xl font-bold text-gray-900">
                Trading Signals
            </h1>

            <p class="mt-2 text-gray-500">
                Manage, monitor and control all trading signals.
            </p>

        </div>

        <a href="{{ route('admin.signals.create') }}">

            <x-admin.button>

                + Create Signal

            </x-admin.button>

        </a>

    </div>

    {{-- ========================================================= --}}
    {{-- Statistics --}}
    {{-- ========================================================= --}}

    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-5 gap-6">

        <x-admin.stat-card
            title="Drafts"
            :value="$drafts"
            color="gray"
        />

        <x-admin.stat-card
            title="Approved"
            :value="$approved"
            color="blue"
        />

        <x-admin.stat-card
            title="Published"
            :value="$published"
            color="green"
        />

        <x-admin.stat-card
            title="Running"
            :value="$running"
            color="indigo"
        />

        <x-admin.stat-card
            title="Closed"
            :value="$closed"
            color="purple"
        />

    </div>

    {{-- ========================================================= --}}
    {{-- Search & Filters --}}
    {{-- ========================================================= --}}

    <x-admin.card>

        <form method="GET">

            <div class="grid grid-cols-1 md:grid-cols-5 gap-4">

                <input
                    type="text"
                    name="search"
                    value="{{ request('search') }}"
                    placeholder="Search Symbol..."
                    class="border rounded-lg px-4 py-3"
                >

                <select
                    name="status"
                    class="border rounded-lg px-4 py-3"
                >

                    <option value="">
                        All Statuses
                    </option>

                    @foreach(\App\Models\Signal::statuses() as $status)

                        <option
                            value="{{ $status }}"
                            @selected(request('status') == $status)
                        >

                            {{ $status }}

                        </option>

                    @endforeach

                </select>

                <select
                    name="direction"
                    class="border rounded-lg px-4 py-3"
                >

                    <option value="">
                        Direction
                    </option>

                    <option
                        value="BUY"
                        @selected(request('direction') == 'BUY')
                    >
                        BUY
                    </option>

                    <option
                        value="SELL"
                        @selected(request('direction') == 'SELL')
                    >
                        SELL
                    </option>

                </select>

                <select
                    name="timeframe"
                    class="border rounded-lg px-4 py-3"
                >

                    <option value="">
                        Timeframe
                    </option>

                    @foreach([
                        'M1',
                        'M5',
                        'M15',
                        'M30',
                        'H1',
                        'H4',
                        'D1',
                        'W1',
                    ] as $timeframe)

                        <option
                            value="{{ $timeframe }}"
                            @selected(request('timeframe') == $timeframe)
                        >

                            {{ $timeframe }}

                        </option>

                    @endforeach

                </select>

                <div class="flex gap-2">

                    <x-admin.button>

                        Filter

                    </x-admin.button>

                    <a
                        href="{{ route('admin.signals.index') }}"
                        class="px-5 py-2 rounded-lg font-medium bg-gray-200 hover:bg-gray-300"
                    >

                        Reset

                    </a>

                </div>

            </div>

        </form>

    </x-admin.card>
        {{-- ========================================================= --}}
    {{-- Signals Table --}}
    {{-- ========================================================= --}}

    <x-admin.card title="All Trading Signals">

        <div class="overflow-x-auto">

            <table class="min-w-full">

                <thead class="bg-gray-50 border-b">

                    <tr>

                        <th class="px-6 py-4 text-left">
                            Symbol
                        </th>

                        <th class="px-6 py-4 text-left">
                            Direction
                        </th>

                        <th class="px-6 py-4 text-left">
                            Entry
                        </th>

                        <th class="px-6 py-4 text-left">
                            Stop Loss
                        </th>

                        <th class="px-6 py-4 text-left">
                            Take Profits
                        </th>

                        <th class="px-6 py-4 text-left">
                            Quality
                        </th>

                        <th class="px-6 py-4 text-left">
                            Status
                        </th>

                        <th class="px-6 py-4 text-left">
                            Visibility
                        </th>

                        <th class="px-6 py-4 text-left">
                            Published
                        </th>

                        <th class="px-6 py-4 text-center">
                            Actions
                        </th>

                    </tr>

                </thead>

                <tbody>

                @forelse($signals as $signal)

                    <tr class="border-b hover:bg-gray-50 transition">

                        {{-- Symbol --}}

                        <td class="px-6 py-5">

                            <div class="font-semibold">

                                <a
                                    href="{{ route('admin.signals.show', $signal) }}"
                                    class="text-blue-600 hover:text-blue-800 hover:underline"
                                >

                                    {{ $signal->symbol?->symbol }}

                                </a>

                            </div>

                            <div class="text-sm text-gray-500">

                                {{ $signal->symbol?->name }}

                            </div>

                        </td>

                        {{-- Direction --}}

                        <td class="px-6 py-5">

                            <x-signal.direction
                                :direction="$signal->direction"
                            />

                        </td>

                        {{-- Entry --}}

                        <td class="px-6 py-5">

                            {{ number_format($signal->entry_price, 5) }}

                        </td>

                        {{-- Stop Loss --}}

                        <td class="px-6 py-5">

                            {{ number_format($signal->stop_loss, 5) }}

                        </td>

                        {{-- Take Profits --}}

                        <td class="px-6 py-5 text-sm">

                            <div class="space-y-1">

                                <div>

                                    TP1:
                                    {{ number_format($signal->take_profit, 5) }}

                                </div>

                                @if($signal->take_profit_2)

                                    <div>

                                        TP2:
                                        {{ number_format($signal->take_profit_2, 5) }}

                                    </div>

                                @endif

                                @if($signal->take_profit_3)

                                    <div>

                                        TP3:
                                        {{ number_format($signal->take_profit_3, 5) }}

                                    </div>

                                @endif

                            </div>

                        </td>

                        {{-- Quality --}}

                        <td class="px-6 py-5">

                            <span class="font-semibold text-blue-600">

                                {{ $signal->signal_quality }}%

                            </span>

                        </td>

                        {{-- Status --}}

                        <td class="px-6 py-5">

                            <x-signal.badge
                                :status="$signal->status"
                            />

                        </td>
                        <td class="px-6 py-5">

                        <x-signal.visibility-badge
                            :visibility="$signal->visibility"
                        />

                        </td>

                        {{-- Published --}}

                        <td class="px-6 py-5">

                            {{ $signal->published_at?->format('d M Y') ?? '--' }}

                        </td>

                        {{-- Actions --}}

                        <td class="px-6 py-5">

                            <div class="flex flex-wrap gap-2 justify-center">

                                <a href="{{ route('admin.signals.show', $signal) }}">

                                    <x-admin.button type="primary">

                                        View

                                    </x-admin.button>

                                </a>

                                <a href="{{ route('admin.signals.edit', $signal) }}">

                                    <x-admin.button type="secondary">

                                        Edit

                                    </x-admin.button>

                                </a>

                                <x-signal.workflow-button
                                    :signal="$signal"
                                />

                                <form
                                    method="POST"
                                    action="{{ route('admin.signals.destroy', $signal) }}"
                                    onsubmit="return confirm('Delete this signal?')"
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
                            colspan="10"
                            class="py-16 text-center text-gray-500"
                        >

                            No trading signals found.

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

        {{ $signals->links() }}

    </div>

</div>

@endsection