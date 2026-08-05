@extends('layouts.app')

@section('title', 'Subscription Details')

@section('content')

<div class="max-w-4xl mx-auto">

    <div class="bg-white rounded-xl shadow p-6">

        <h2 class="text-2xl font-bold mb-6">
            Subscription Details
        </h2>

        <div class="space-y-3">

            <p>
                <strong>User:</strong>
                {{ $subscription->user->name }}
            </p>

            <p>
                <strong>Email:</strong>
                {{ $subscription->user->email }}
            </p>

            <p>
                <strong>Plan:</strong>
                {{ $subscription->plan->name }}
            </p>

            <p>
                <strong>Status:</strong>
                {{ ucfirst($subscription->status) }}
            </p>

            <p>
                <strong>Starts:</strong>
                {{ optional($subscription->starts_at)->format('d M Y') }}
            </p>

            <p>
                <strong>Expires:</strong>
                {{ optional($subscription->expires_at)->format('d M Y') }}
            </p>

            <p>
                <strong>Auto Renew:</strong>
                {{ $subscription->auto_renew ? 'Yes' : 'No' }}
            </p>

        </div>

    </div>

</div>

@endsection