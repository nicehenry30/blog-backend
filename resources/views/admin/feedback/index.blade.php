@extends('layouts.app')

@section('title', 'Feedback')

@section('content')

{{-- ========================================================= --}}
{{-- Page Header --}}
{{-- ========================================================= --}}

<div class="flex flex-col md:flex-row md:items-center md:justify-between gap-6">

    <div>

        <h1 class="text-3xl font-bold text-gray-900">
            User Feedback
        </h1>

        <p class="mt-2 text-gray-500">
            Review feedback submitted by Tradewisser users.
        </p>

    </div>

</div>


{{-- ========================================================= --}}
{{-- Feedback Statistics --}}
{{-- ========================================================= --}}

<div class="grid grid-cols-1 md:grid-cols-3 gap-6">

    <x-admin.stat-card
        title="Total Feedback"
        :value="$feedback->total()"
        color="gray"
    />

    <x-admin.stat-card
        title="Pending"
        :value="$feedback->where('status', 'pending')->count()"
        color="yellow"
    />

    <x-admin.stat-card
        title="Resolved"
        :value="$feedback->where('status', 'resolved')->count()"
        color="green"
    />

</div>


{{-- ========================================================= --}}
{{-- Feedback Table --}}
{{-- ========================================================= --}}

<x-admin.card title="All Feedback">

    <div class="overflow-x-auto">

        <table class="min-w-full">

            <thead class="bg-gray-50 border-b">

                <tr>

                    <th class="px-6 py-4 text-left">
                        User
                    </th>

                    <th class="px-6 py-4 text-left">
                        Category
                    </th>

                    <th class="px-6 py-4 text-left">
                        Subject
                    </th>

                    <th class="px-6 py-4 text-left">
                        Status
                    </th>

                    <th class="px-6 py-4 text-left">
                        Date
                    </th>

                    <th class="px-6 py-4 text-center">
                        Action
                    </th>

                </tr>

            </thead>


            <tbody>

                @forelse($feedback as $item)

                    <tr class="border-b hover:bg-gray-50 transition">

                        {{-- User --}}

                        <td class="px-6 py-5">

                            <div class="font-semibold text-gray-900">
                                {{ $item->user?->name ?? 'Unknown User' }}
                            </div>

                            <div class="text-sm text-gray-500">
                                {{ $item->user?->email }}
                            </div>

                        </td>


                        {{-- Category --}}

                        <td class="px-6 py-5">

                            <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-700">

                                {{ ucfirst($item->category) }}

                            </span>

                        </td>


                        {{-- Subject --}}

                        <td class="px-6 py-5">

                            <div class="font-medium text-gray-900">
                                {{ $item->subject }}
                            </div>

                        </td>


                        {{-- Status --}}

                        <td class="px-6 py-5">

                            @if($item->status === 'pending')

                                <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                    Pending
                                </span>

                            @elseif($item->status === 'in_progress')

                                <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                    In Progress
                                </span>

                            @elseif($item->status === 'resolved')

                                <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                    Resolved
                                </span>

                            @elseif($item->status === 'closed')

                                <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-gray-200 text-gray-800">
                                    Closed
                                </span>

                            @endif

                        </td>


                        {{-- Date --}}

                        <td class="px-6 py-5 text-sm text-gray-500">

                            {{ $item->created_at->format('d M Y H:i') }}

                        </td>


                        {{-- Action --}}

                        <td class="px-6 py-5 text-center">

                            <a
                                href="{{ route('admin.feedback.show', $item) }}"
                                class="inline-flex items-center px-4 py-2 rounded-lg bg-blue-600 text-white text-sm font-medium hover:bg-blue-700 transition"
                            >
                                View
                            </a>

                        </td>

                    </tr>

                @empty

                    <tr>

                        <td
                            colspan="6"
                            class="px-6 py-10 text-center text-gray-500"
                        >

                            No feedback has been submitted yet.

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

    {{ $feedback->links() }}

</div>

@endsection