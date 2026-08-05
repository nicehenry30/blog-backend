@extends('layouts.app')

@section('title', 'Plan Details')

@section('content')

<div class="max-w-4xl mx-auto">

    <div class="bg-white rounded-xl shadow p-6">

        <h2 class="text-2xl font-bold mb-4">
            {{ $plan->name }}
        </h2>

        <p class="mb-4">
            {{ $plan->description }}
        </p>

        <div class="space-y-2">

            <p>
                <strong>Price:</strong>
                {{ $plan->currency }}
                {{ number_format($plan->price, 2) }}
            </p>

            <p>
                <strong>Billing Cycle:</strong>
                {{ ucfirst($plan->billing_cycle) }}
            </p>

            <p>
                <strong>Status:</strong>
                {{ $plan->is_active ? 'Active' : 'Inactive' }}
            </p>

        </div>

    </div>

</div>

@endsection