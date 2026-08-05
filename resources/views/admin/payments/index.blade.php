@extends('layouts.app')

@section('title', 'Payments')

@section('content')

<div class="flex items-center justify-between mb-6">

    <div>
        <h2 class="text-2xl font-bold">
            Payments
        </h2>

        <p class="text-gray-500">
            Manage all customer payments.
        </p>
    </div>

</div>

<div class="bg-white rounded-xl shadow">

    <table class="w-full">

        <thead class="bg-gray-100">

        <tr>

            <th class="px-6 py-4 text-left">User</th>
            <th class="px-6 py-4 text-left">Plan</th>
            <th class="px-6 py-4 text-left">Gateway</th>
            <th class="px-6 py-4 text-left">Amount</th>
            <th class="px-6 py-4 text-left">Status</th>
            <th class="px-6 py-4 text-left">Date</th>
            <th class="px-6 py-4 text-left">Actions</th>

        </tr>

        </thead>

        <tbody>

        @forelse($payments as $payment)

            <tr class="border-t">

                <td class="px-6 py-4">
                    {{ $payment->user->name }}
                </td>

                <td class="px-6 py-4">
                    {{ $payment->plan->name }}
                </td>

                <td class="px-6 py-4">
                    {{ ucfirst($payment->gateway) }}
                </td>

                <td class="px-6 py-4">
                    {{ $payment->currency }}
                    {{ number_format($payment->amount, 2) }}
                </td>

                <td class="px-6 py-4">

                    <span class="px-3 py-1 rounded-full bg-gray-200">
                        {{ ucfirst($payment->status) }}
                    </span>

                </td>

                <td class="px-6 py-4">
                    {{ optional($payment->created_at)->format('d M Y') }}
                </td>

                <td class="px-6 py-4">

                    <a
                        href="{{ route('admin.payments.show', $payment) }}"
                        class="text-green-600"
                    >
                        View
                    </a>

                    |

                    <a
                        href="{{ route('admin.payments.edit', $payment) }}"
                        class="text-blue-600"
                    >
                        Edit
                    </a>

                </td>

            </tr>

        @empty

            <tr>

                <td
                    colspan="7"
                    class="text-center py-10 text-gray-500"
                >
                    No payments found.
                </td>

            </tr>

        @endforelse

        </tbody>

    </table>

</div>

@if($payments->hasPages())

<div class="mt-6">

    {{ $payments->links() }}

</div>

@endif

@endsection