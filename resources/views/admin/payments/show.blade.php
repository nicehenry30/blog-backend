@extends('layouts.app')

@section('title', 'Payment Details')

@section('content')

<div class="max-w-4xl mx-auto">

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
                {{ ucfirst($payment->status) }}
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

</div>

@endsection