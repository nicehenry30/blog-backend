@extends('layouts.app')

@section('title', 'Subscription Plans')

@section('content')

<div class="space-y-6">

    {{-- Header --}}
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">

        <div>
            <h2 class="text-2xl font-bold">
                Subscription Plans
            </h2>

            <p class="text-gray-500">
                Manage pricing, billing periods, features, and plan status.
            </p>
        </div>

        <a
            href="{{ route('admin.plans.create') }}"
            class="inline-flex items-center justify-center bg-blue-600 hover:bg-blue-700 text-white px-5 py-3 rounded-lg font-medium"
        >
            + Create Plan
        </a>

    </div>


    {{-- Success Message --}}
    @if(session('success'))

        <div class="bg-green-100 border border-green-200 text-green-700 px-4 py-3 rounded-lg">
            {{ session('success') }}
        </div>

    @endif


    {{-- Validation Errors --}}
    @if($errors->any())

        <div class="bg-red-100 border border-red-200 text-red-700 px-4 py-3 rounded-lg">

            <ul class="list-disc list-inside">

                @foreach($errors->all() as $error)

                    <li>{{ $error }}</li>

                @endforeach

            </ul>

        </div>

    @endif


    {{-- Plans Table --}}
    <div class="bg-white rounded-xl shadow-sm border overflow-hidden">

        <div class="overflow-x-auto">

            <table class="w-full">

                <thead class="bg-gray-100">

                <tr>

                    <th class="text-left px-6 py-4">
                        Plan
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

                    <tr class="border-t hover:bg-gray-50">

                        {{-- Plan --}}
                        <td class="px-6 py-4">

                            <div class="font-semibold">
                                {{ $plan->name }}
                            </div>

                            <div class="text-sm text-gray-500">
                                {{ $plan->slug }}
                            </div>

                        </td>


                        {{-- Price --}}
                        <td class="px-6 py-4">

                            <span class="font-semibold">
                                {{ $plan->currency }}
                                {{ number_format($plan->price, 2) }}
                            </span>

                        </td>


                        {{-- Billing --}}
                        <td class="px-6 py-4">

                            @switch($plan->billing_cycle)

                                @case('monthly')
                                    1 Month
                                    @break

                                @case('three_months')
                                    3 Months
                                    @break

                                @case('yearly')
                                    1 Year
                                    @break

                                @case('two_year')
                                    2 Years
                                    @break

                                @default
                                    {{ $plan->billing_cycle }}

                            @endswitch

                        </td>


                        {{-- Features --}}
                        <td class="px-6 py-4">

                            <span class="font-medium">
                                {{ $plan->features_count }}
                            </span>

                        </td>


                        {{-- Status --}}
                        <td class="px-6 py-4">

                            @if($plan->is_active)

                                <span class="inline-flex px-3 py-1 rounded-full bg-green-100 text-green-700 text-sm font-medium">
                                    Active
                                </span>

                            @else

                                <span class="inline-flex px-3 py-1 rounded-full bg-red-100 text-red-700 text-sm font-medium">
                                    Disabled
                                </span>

                            @endif

                        </td>


                        {{-- Actions --}}
                        <td class="px-6 py-4">

                            <div class="flex items-center gap-3">

                                <a
                                    href="{{ route('admin.plans.show', $plan) }}"
                                    class="text-gray-600 hover:text-gray-900"
                                >
                                    View
                                </a>

                                <a
                                    href="{{ route('admin.plans.edit', $plan) }}"
                                    class="text-blue-600 hover:text-blue-800 font-medium"
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
                                        type="submit"
                                        onclick="return confirm('Delete this plan?')"
                                        class="text-red-600 hover:text-red-800"
                                    >
                                        Delete
                                    </button>

                                </form>

                            </div>

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

    </div>


    {{-- Pagination --}}
    @if($plans->hasPages())

        <div>
            {{ $plans->links() }}
        </div>

    @endif

</div>

@endsection