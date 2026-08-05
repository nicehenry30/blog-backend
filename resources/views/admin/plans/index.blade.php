@extends('layouts.app')

@section('title', 'Subscription Plans')

@section('content')

<div class="flex items-center justify-between mb-6">

    <div>
        <h2 class="text-2xl font-bold">
            Subscription Plans
        </h2>

        <p class="text-gray-500">
            Manage all subscription plans.
        </p>
    </div>

    <a
        href="{{ route('admin.plans.create') }}"
        class="bg-blue-600 hover:bg-blue-700 text-white px-5 py-3 rounded-lg font-medium"
    >
        + Create Plan
    </a>

</div>

<div class="bg-white rounded-xl shadow">

    <table class="w-full">

        <thead class="bg-gray-100">

        <tr>

            <th class="text-left px-6 py-4">
                Name
            </th>

            <th class="text-left px-6 py-4">
                Price
            </th>

            <th class="text-left px-6 py-4">
                Billing
            </th>

            <th class="text-left px-6 py-4">
                Features
            </th>

            <th class="text-left px-6 py-4">
                Status
            </th>

            <th class="text-left px-6 py-4">
                Actions
            </th>

        </tr>

        </thead>

        <tbody>

        @forelse($plans as $plan)

            <tr class="border-t">

                <td class="px-6 py-4 font-semibold">
                    {{ $plan->name }}
                </td>

                <td class="px-6 py-4">
                    {{ $plan->currency }}
                    {{ number_format($plan->price, 2) }}
                </td>

                <td class="px-6 py-4">
                    {{ ucfirst($plan->billing_cycle) }}
                </td>

                <td class="px-6 py-4">
                    {{ $plan->features_count }}
                </td>

                <td class="px-6 py-4">

                    @if($plan->is_active)

                        <span class="px-3 py-1 rounded-full bg-green-100 text-green-700">
                            Active
                        </span>

                    @else

                        <span class="px-3 py-1 rounded-full bg-red-100 text-red-700">
                            Disabled
                        </span>

                    @endif

                </td>

                <td class="px-6 py-4 space-x-3">

                    <a
                        href="{{ route('admin.plans.edit', $plan) }}"
                        class="text-blue-600"
                    >
                        Edit
                    </a>

                    <form
                        action="{{ route('admin.plans.destroy', $plan) }}"
                        method="POST"
                        class="inline"
                    >
                        @csrf
                        @method('DELETE')

                        <button
                            onclick="return confirm('Delete this plan?')"
                            class="text-red-600"
                        >
                            Delete
                        </button>

                    </form>

                </td>

            </tr>

        @empty

            <tr>

                <td
                    colspan="6"
                    class="text-center py-10 text-gray-500"
                >
                    No subscription plans found.
                </td>

            </tr>

        @endforelse

        </tbody>

    </table>

</div>

@if($plans->hasPages())

<div class="mt-6">

    {{ $plans->links() }}

</div>

@endif

@endsection