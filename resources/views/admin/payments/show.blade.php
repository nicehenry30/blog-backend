@extends('layouts.app')

@section('title', 'Payment Details')

@section('content')

<div class="max-w-4xl mx-auto space-y-6">

    {{-- Success Message --}}
    @if (session('success'))
        <div class="bg-green-100 border border-green-300 text-green-800 rounded-xl p-4">
            {{ session('success') }}
        </div>
    @endif

    {{-- Error Message --}}
    @if (session('error'))
        <div class="bg-red-100 border border-red-300 text-red-800 rounded-xl p-4">
            {{ session('error') }}
        </div>
    @endif


    {{-- Payment Details --}}
    <div class="bg-white rounded-xl shadow p-6">

        <h2 class="text-2xl font-bold mb-6">
            Payment Details
        </h2>

        <div class="space-y-3">

            <p>
                <strong>User:</strong>
                {{ $payment->user->name }}
            </p>

            <p>
                <strong>Plan:</strong>
                {{ $payment->plan->name }}
            </p>

            <p>
                <strong>Gateway:</strong>
                {{ ucfirst($payment->gateway) }}
            </p>

            <p>
                <strong>Amount:</strong>
                {{ $payment->currency }}
                {{ number_format($payment->amount, 2) }}
            </p>

            <p>
                <strong>Status:</strong>

                @if ($payment->status === 'successful')
                    <span class="inline-block px-2 py-1 text-sm font-semibold rounded bg-green-100 text-green-800">
                        Successful
                    </span>
                @elseif ($payment->status === 'pending')
                    <span class="inline-block px-2 py-1 text-sm font-semibold rounded bg-yellow-100 text-yellow-800">
                        Pending
                    </span>
                @elseif ($payment->status === 'failed')
                    <span class="inline-block px-2 py-1 text-sm font-semibold rounded bg-red-100 text-red-800">
                        Failed
                    </span>
                @else
                    <span class="inline-block px-2 py-1 text-sm font-semibold rounded bg-gray-100 text-gray-800">
                        {{ ucfirst($payment->status) }}
                    </span>
                @endif
            </p>

            <p>
                <strong>Reference:</strong>
                {{ $payment->reference ?? '--' }}
            </p>

            <p>
                <strong>Gateway Reference:</strong>
                {{ $payment->gateway_reference ?? '--' }}
            </p>

        </div>

    </div>


    {{-- ========================================================= --}}
    {{-- CRYPTO PAYMENT DETAILS                                   --}}
    {{-- ========================================================= --}}

    @if ($payment->gateway === 'crypto')

        <div class="bg-white rounded-xl shadow p-6">

            <div class="flex items-center justify-between mb-6">

                <h2 class="text-2xl font-bold">
                    Crypto Payment
                </h2>

                <span class="px-3 py-1 text-sm font-semibold rounded-full bg-blue-100 text-blue-800">
                    USDT
                </span>

            </div>


            <div class="space-y-5">

                {{-- Cryptocurrency --}}
                <div>
                    <p class="text-sm text-gray-500 mb-1">
                        Cryptocurrency
                    </p>

                    <p class="font-semibold text-lg">
                        {{ $payment->gateway_currency ?? 'USDT' }}
                    </p>
                </div>


                {{-- Network --}}
                <div>
                    <p class="text-sm text-gray-500 mb-1">
                        Network
                    </p>

                    <p class="font-semibold text-lg">
                        {{ $payment->crypto_network ?? 'TRC20' }}
                    </p>
                </div>


                {{-- Amount --}}
                <div>
                    <p class="text-sm text-gray-500 mb-1">
                        Amount
                    </p>

                    <p class="font-semibold text-lg">
                        {{ number_format($payment->gateway_amount, 2) }}
                        {{ $payment->gateway_currency ?? 'USDT' }}
                    </p>
                </div>


                {{-- Receiving Wallet --}}
                <div>
                    <p class="text-sm text-gray-500 mb-1">
                        Receiving Wallet
                    </p>

                    <div class="font-mono text-sm break-all bg-gray-100 rounded-lg p-3">
                        {{ $payment->crypto_address ?? '--' }}
                    </div>
                </div>


                {{-- Transaction Hash --}}
                <div>
                    <p class="text-sm text-gray-500 mb-1">
                        Transaction Hash
                    </p>

                    @if ($payment->transaction_hash)

                        <div class="font-mono text-sm break-all bg-gray-100 rounded-lg p-3">
                            {{ $payment->transaction_hash }}
                        </div>

                    @else

                        <p class="text-gray-500">
                            Not submitted yet
                        </p>

                    @endif
                </div>


                {{-- Submitted At --}}
                <div>
                    <p class="text-sm text-gray-500 mb-1">
                        Submitted At
                    </p>

                    <p class="font-semibold">
                        {{ $payment->submitted_at?->format('Y-m-d H:i:s') ?? '--' }}
                    </p>
                </div>


                {{-- Reviewed At --}}
                <div>
                    <p class="text-sm text-gray-500 mb-1">
                        Reviewed At
                    </p>

                    <p class="font-semibold">
                        {{ $payment->reviewed_at?->format('Y-m-d H:i:s') ?? '--' }}
                    </p>
                </div>


                {{-- Reviewed By --}}
                <div>
                    <p class="text-sm text-gray-500 mb-1">
                        Reviewed By
                    </p>

                    <p class="font-semibold">
                        {{ $payment->reviewer?->name ?? '--' }}
                    </p>
                </div>

            </div>

        </div>


        {{-- ===================================================== --}}
        {{-- CRYPTO PAYMENT REVIEW                                 --}}
        {{-- ===================================================== --}}

        @if (
            $payment->status === 'pending' &&
            $payment->transaction_hash
        )

            <div class="bg-yellow-50 border border-yellow-300 rounded-xl p-6">

                <div class="flex items-start gap-3 mb-5">

                    <div class="text-yellow-600 text-xl">
                        ⚠
                    </div>

                    <div>
                        <h2 class="text-xl font-bold text-yellow-800">
                            Waiting for Approval
                        </h2>

                        <p class="text-yellow-700 mt-1">
                            The user has submitted a transaction hash.
                            Verify the transaction on the TRC20 blockchain
                            before approving this payment.
                        </p>
                    </div>

                </div>


                {{-- Transaction Verification Information --}}
                <div class="bg-white border border-yellow-200 rounded-lg p-4 mb-6">

                    <p class="text-sm text-gray-500 mb-1">
                        Amount to Verify
                    </p>

                    <p class="text-lg font-bold">
                        {{ number_format($payment->gateway_amount, 2) }}
                        {{ $payment->gateway_currency ?? 'USDT' }}
                    </p>

                    <p class="text-sm text-gray-500 mt-4 mb-1">
                        Network
                    </p>

                    <p class="font-semibold">
                        {{ $payment->crypto_network ?? 'TRC20' }}
                    </p>

                    <p class="text-sm text-gray-500 mt-4 mb-1">
                        Receiving Address
                    </p>

                    <p class="font-mono text-sm break-all">
                        {{ $payment->crypto_address ?? '--' }}
                    </p>

                    <p class="text-sm text-gray-500 mt-4 mb-1">
                        Submitted Transaction Hash
                    </p>

                    <p class="font-mono text-sm break-all">
                        {{ $payment->transaction_hash }}
                    </p>

                </div>


                {{-- Action Buttons --}}
                <div class="flex flex-wrap gap-3">

                    {{-- Approve --}}
                    <form
                        method="POST"
                        action="{{ route(
                            'admin.payments.approve-crypto',
                            $payment
                        ) }}"
                        onsubmit="return confirm(
                            'Are you sure you have verified this transaction on the TRC20 blockchain and want to approve this payment?'
                        );"
                    >

                        @csrf

                        @method('PATCH')

                        <button
                            type="submit"
                            class="px-5 py-2.5 bg-green-600 hover:bg-green-700 text-white font-semibold rounded-lg transition"
                        >
                            Approve Payment
                        </button>

                    </form>


                    {{-- Reject --}}
                    <form
                        method="POST"
                        action="{{ route(
                            'admin.payments.reject-crypto',
                            $payment
                        ) }}"
                        onsubmit="return confirm(
                            'Are you sure you want to reject this crypto payment?'
                        );"
                    >

                        @csrf

                        @method('PATCH')

                        <button
                            type="submit"
                            class="px-5 py-2.5 bg-red-600 hover:bg-red-700 text-white font-semibold rounded-lg transition"
                        >
                            Reject Payment
                        </button>

                    </form>

                </div>

            </div>


        {{-- ===================================================== --}}
        {{-- CRYPTO STATUS                                         --}}
        {{-- ===================================================== --}}

        @else

            <div class="bg-gray-50 border border-gray-200 rounded-xl p-6">

                <h2 class="text-xl font-bold mb-3">
                    Crypto Payment Status
                </h2>


                @if ($payment->status === 'pending')

                    @if (!$payment->transaction_hash)

                        <p class="text-gray-600">
                            Waiting for the user to submit a transaction hash.
                        </p>

                    @else

                        <p class="text-yellow-700 font-semibold">
                            Transaction submitted and awaiting review.
                        </p>

                    @endif


                @elseif ($payment->status === 'successful')

                    <p class="text-green-600 font-semibold">
                        Payment approved successfully.
                    </p>

                    @if ($payment->reviewed_at)

                        <p class="text-sm text-gray-500 mt-2">
                            Reviewed on
                            {{ $payment->reviewed_at->format('Y-m-d H:i:s') }}
                        </p>

                    @endif


                @elseif ($payment->status === 'failed')

                    <p class="text-red-600 font-semibold">
                        Payment rejected.
                    </p>

                    @if ($payment->reviewed_at)

                        <p class="text-sm text-gray-500 mt-2">
                            Rejected on
                            {{ $payment->reviewed_at->format('Y-m-d H:i:s') }}
                        </p>

                    @endif


                @else

                    <p class="text-gray-600">
                        {{ ucfirst($payment->status) }}
                    </p>

                @endif

            </div>

        @endif

    @endif

</div>

@endsection