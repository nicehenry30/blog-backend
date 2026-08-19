@extends('layouts.app')

@section('title', 'Market Alerts')

@section('content')

{{-- ========================================================= --}}
{{-- Page Header --}}
{{-- ========================================================= --}}

<div class="flex flex-col md:flex-row md:items-center md:justify-between gap-6">

    <div>

        <h1 class="text-3xl font-bold text-gray-900">
            Market Alerts
        </h1>

        <p class="mt-2 text-gray-500">
            Manage market news and trading caution alerts.
        </p>

    </div>

    <a href="{{ route('admin.market-alerts.create') }}">

        <x-admin.button>
            + Create Market Alert
        </x-admin.button>

    </a>

</div>


{{-- ========================================================= --}}
{{-- Alert Statistics --}}
{{-- ========================================================= --}}

<div class="grid grid-cols-1 md:grid-cols-3 gap-6">

    <x-admin.stat-card
        title="Total Alerts"
        :value="$alerts->total()"
        color="gray"
    />

    <x-admin.stat-card
        title="Active Alerts"
        :value="$activeAlerts"
        color="green"
    />

    <x-admin.stat-card
        title="High Impact"
        :value="$highImpactAlerts"
        color="red"
    />

</div>


{{-- ========================================================= --}}
{{-- Alerts Table --}}
{{-- ========================================================= --}}

<x-admin.card title="All Market Alerts">

    <div class="overflow-x-auto">

        <table class="min-w-full">

            <thead class="bg-gray-50 border-b">

                <tr>

                    <th class="px-6 py-4 text-left">
                        Title
                    </th>

                    <th class="px-6 py-4 text-left">
                        Symbol
                    </th>

                    <th class="px-6 py-4 text-left">
                        Impact
                    </th>

                    <th class="px-6 py-4 text-left">
                        Alert Time
                    </th>

                    <th class="px-6 py-4 text-left">
                        Status
                    </th>

                    <th class="px-6 py-4 text-center">
                        Actions
                    </th>

                </tr>

            </thead>

            <tbody>

                @forelse($alerts as $alert)

                    <tr class="border-b hover:bg-gray-50 transition">

                        {{-- Title --}}

                        <td class="px-6 py-5">

                            <div class="font-semibold">

                                <a
                                    href="{{ route('admin.market-alerts.show', $alert) }}"
                                    class="text-blue-600 hover:text-blue-800 hover:underline"
                                >
                                    {{ $alert->title }}
                                </a>

                            </div>

                            <div class="text-sm text-gray-500 mt-1">

                                {{ Str::limit(
                                    $alert->recommendation,
                                    60
                                ) }}

                            </div>

                        </td>


                        {{-- Symbol --}}

                        <td class="px-6 py-5">

                            <span class="font-semibold">
                                {{ $alert->symbol }}
                            </span>

                        </td>


                        {{-- Impact --}}

                        <td class="px-6 py-5">

                            @if($alert->impact === 'high')

                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-red-100 text-red-700">
                                    🔴 High
                                </span>

                            @elseif($alert->impact === 'medium')

                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-yellow-100 text-yellow-700">
                                    🟡 Medium
                                </span>

                            @else

                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-green-100 text-green-700">
                                    🟢 Low
                                </span>

                            @endif

                        </td>


                        {{-- Alert Time --}}

                        <td class="px-6 py-5">

                            <div class="font-medium">
                                {{ $alert->alert_time->format('d M Y') }}
                            </div>

                            <div class="text-sm text-gray-500">
                                {{ $alert->alert_time->format('H:i') }}
                            </div>

                        </td>


                        {{-- Status --}}

                        <td class="px-6 py-5">

                            @if($alert->status === 'upcoming')

                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-blue-100 text-blue-700">
                                    Upcoming
                                </span>

                            @elseif($alert->status === 'live')

                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-red-100 text-red-700">
                                    🔴 Live
                                </span>

                            @elseif($alert->status === 'finished')

                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-gray-100 text-gray-600">
                                    Finished
                                </span>

                            @else

                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold bg-gray-100 text-gray-600">
                                    Inactive
                                </span>

                            @endif

                        </td>


                        {{-- Actions --}}

                        <td class="px-6 py-5">

                            <div class="flex flex-wrap gap-2 justify-center">

                                {{-- View --}}

                                <a
                                    href="{{ route('admin.market-alerts.show', $alert) }}"
                                >

                                    <x-admin.button type="primary">
                                        View
                                    </x-admin.button>

                                </a>


                                {{-- Edit --}}

                                <a
                                    href="{{ route('admin.market-alerts.edit', $alert) }}"
                                >

                                    <x-admin.button type="secondary">
                                        Edit
                                    </x-admin.button>

                                </a>


                                {{-- Delete --}}

                                <form
                                    method="POST"
                                    action="{{ route('admin.market-alerts.destroy', $alert) }}"
                                    onsubmit="return confirm('Delete this market alert?')"
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
                            colspan="6"
                            class="py-16 text-center text-gray-500"
                        >

                            No market alerts found.

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

    {{ $alerts->links() }}

</div>

@endsection