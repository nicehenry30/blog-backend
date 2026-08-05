@extends('layouts.app')

@section('title', 'Subscriptions')

@section('content')

<div class="flex items-center justify-between mb-6">

    <div>

        <h2 class="text-2xl font-bold">
            Subscriptions
        </h2>

        <p class="text-gray-500">
            Manage all customer subscriptions.
        </p>

    </div>

</div>

<div class="bg-white rounded-xl shadow">

    <table class="w-full">

        <thead class="bg-gray-100">

        <tr>

            <th class="text-left px-6 py-4">
                User
            </th>

            <th class="text-left px-6 py-4">
                Plan
            </th>

            <th class="text-left px-6 py-4">
                Status
            </th>

            <th class="text-left px-6 py-4">
                Starts
            </th>

            <th class="text-left px-6 py-4">
                Expires
            </th>

            <th class="text-left px-6 py-4">
                Auto Renew
            </th>

            <th class="text-left px-6 py-4">
                Actions
            </th>

        </tr>

        </thead>

        <tbody>

        @forelse($subscriptions as $subscription)

            <tr class="border-t">

                <td class="px-6 py-4">

                    <div class="font-semibold">
                        {{ $subscription->user->name }}
                    </div>

                    <div class="text-sm text-gray-500">
                        {{ $subscription->user->email }}
                    </div>

                </td>

                <td class="px-6 py-4">
                    {{ $subscription->plan->name }}
                </td>

                <td class="px-6 py-4">

                    <span class="px-3 py-1 rounded-full bg-gray-200">

                        {{ ucfirst($subscription->status) }}

                    </span>

                </td>

                <td class="px-6 py-4">
                    {{ optional($subscription->starts_at)->format('d M Y') }}
                </td>

                <td class="px-6 py-4">
                    {{ optional($subscription->expires_at)->format('d M Y') ?? '--' }}
                </td>

                <td class="px-6 py-4">
                    {{ $subscription->auto_renew ? 'Yes' : 'No' }}
                </td>

                <td class="px-6 py-4 space-x-2">

                    <a
                        href="{{ route('admin.subscriptions.show', $subscription) }}"
                        class="text-green-600"
                    >
                        View
                    </a>

                    <a
                        href="{{ route('admin.subscriptions.edit', $subscription) }}"
                        class="text-blue-600"
                    >
                        Edit
                    </a>

                    <form
                        action="{{ route('admin.subscriptions.destroy', $subscription) }}"
                        method="POST"
                        class="inline"
                    >

                        @csrf
                        @method('DELETE')

                        <button
                            onclick="return confirm('Cancel this subscription?')"
                            class="text-red-600"
                        >
                            Cancel
                        </button>

                    </form>

                </td>

            </tr>

        @empty

            <tr>

                <td
                    colspan="7"
                    class="text-center py-10 text-gray-500"
                >

                    No subscriptions found.

                </td>

            </tr>

        @endforelse

        </tbody>

    </table>

</div>

@if($subscriptions->hasPages())

<div class="mt-6">

    {{ $subscriptions->links() }}

</div>

@endif

@endsection