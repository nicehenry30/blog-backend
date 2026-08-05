@extends('layouts.app')

@section('title', 'Signals')

@section('content')

<div class="flex items-center justify-between mb-6">

    <div>
        <h2 class="text-2xl font-bold">
            Trading Signals
        </h2>

        <p class="text-gray-500">
            Manage all trading signals.
        </p>
    </div>

    <a
        href="{{ route('admin.signals.create') }}"
        class="bg-blue-600 hover:bg-blue-700 text-white px-5 py-3 rounded-lg font-medium"
    >
        + Create Signal
    </a>

</div>


<div class="bg-white rounded-xl shadow">

    <div class="p-6 border-b">

        <input
            type="text"
            placeholder="Search by Symbol..."
            class="w-full border rounded-lg px-4 py-3"
        >

    </div>


    <table class="w-full">

        <thead class="bg-gray-100">

<tr>

    <th class="text-left px-6 py-4">Symbol</th>

    <th class="text-left px-6 py-4">Direction</th>

    <th class="text-left px-6 py-4">Entry</th>

    <th class="text-left px-6 py-4">SL</th>

    <th class="text-left px-6 py-4">TP</th>

    <th class="text-left px-6 py-4">Quality</th>

    <th class="text-left px-6 py-4">Status</th>

    <th class="text-left px-6 py-4">Published</th>

    <th class="text-left px-6 py-4">Actions</th>

</tr>

</thead>

        <tbody>

        @forelse($signals as $signal)

            <tr class="border-t hover:bg-gray-50">

    <td class="px-6 py-4">

        <div class="font-semibold">
            {{ $signal->symbol?->symbol }}
        </div>

        <div class="text-sm text-gray-500">
            {{ $signal->symbol?->name }}
        </div>

    </td>

    <td class="px-6 py-4">

        @if($signal->direction == 'BUY')

            <span class="px-3 py-1 rounded-full bg-green-100 text-green-700 text-sm font-medium">
                BUY
            </span>

        @else

            <span class="px-3 py-1 rounded-full bg-red-100 text-red-700 text-sm font-medium">
                SELL
            </span>

        @endif

    </td>

    <td class="px-6 py-4">
        {{ number_format($signal->entry_price, 5) }}
    </td>

    <td class="px-6 py-4">
        {{ number_format($signal->stop_loss, 5) }}
    </td>

    <td class="px-6 py-4">
        {{ number_format($signal->take_profit, 5) }}
    </td>

    <td class="px-6 py-4">

        <span class="font-semibold text-blue-600">
            {{ $signal->signal_quality }}%
        </span>

    </td>

    <td class="px-6 py-4">

        @php
            $statusColor = match($signal->status) {
                'Published' => 'bg-green-100 text-green-700',
                'Draft' => 'bg-gray-100 text-gray-700',
                'Pending' => 'bg-yellow-100 text-yellow-700',
                'Expired' => 'bg-orange-100 text-orange-700',
                'Cancelled' => 'bg-red-100 text-red-700',
                default => 'bg-gray-100 text-gray-700',
            };
        @endphp

        <span class="px-3 py-1 rounded-full text-sm {{ $statusColor }}">
            {{ $signal->status }}
        </span>

    </td>

    <td class="px-6 py-4">

        {{ $signal->published_at?->format('d M Y') ?? '--' }}

    </td>

    <td class="px-6 py-4">

        <div class="flex gap-3">

            <a href="{{ route('admin.signals.edit', $signal) }}"
               class="text-blue-600 hover:text-blue-800 font-medium">

                Edit

            </a>

            @if($signal->status !== 'Published')

                <form method="POST"
                      action="{{ route('admin.signals.publish', $signal) }}">

                    @csrf
                    @method('PATCH')

                    <button
                        class="text-green-600 hover:text-green-800 font-medium">

                        Publish

                    </button>

                </form>

            @endif

            <form method="POST"
                  action="{{ route('admin.signals.destroy', $signal) }}"
                  onsubmit="return confirm('Delete this signal?')">

                @csrf
                @method('DELETE')

                <button
                    class="text-red-600 hover:text-red-800 font-medium">

                    Delete

                </button>

            </form>

        </div>

    </td>

</tr>



         //<td>
            <div class="font-semibold">
                {{ $signal->symbol?->symbol }}
            </div>

            <div class="text-sm text-gray-500">
                {{ $signal->symbol?->name }}
            </div>
        </td>

                <td class="px-6 py-4">
                    {{ $signal->direction }}
                </td>

                <td class="px-6 py-4">

                    <span
                        class="px-3 py-1 rounded-full text-sm bg-gray-200"
                    >
                        {{ $signal->status }}
                    </span>

                </td>

                <td class="px-6 py-4">
                    {{ $signal->signal_quality }}
                </td>

                <td class="px-6 py-4">
                    {{ $signal->published_at ?? '--' }}
                </td>

                <td class="px-6 py-4 space-x-2">

                    <a
                        href="{{ route('admin.signals.edit', $signal) }}"
                        class="text-blue-600"
                    >
                        Edit
                    </a>

                    <button
                        class="text-red-600"
                    >
                        Delete
                    </button>

                </td>

            </tr>

        @empty

            <tr>

                <td
                    colspan="6"
                    class="text-center py-10 text-gray-500"
                >

                    No trading signals found.

                </td>

            </tr>

        @endforelse

        </tbody>

    </table>

</div>

@if($signals->hasPages())

<div class="mt-6">

    {{ $signals->links() }}

</div>

@endif

@endsection

