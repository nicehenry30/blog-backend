@extends('layouts.app')

@section('title', 'Dashboard')

@section('content')

<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">

    <div class="bg-white rounded-xl shadow p-6">
        <h3 class="text-gray-500 text-sm">Total Signals</h3>
        <p class="text-3xl font-bold mt-2">
            {{ $totalSignals ?? 0 }}
        </p>
    </div>

    <div class="bg-white rounded-xl shadow p-6">
        <h3 class="text-gray-500 text-sm">Published Signals</h3>
        <p class="text-3xl font-bold mt-2 text-green-600">
            {{ $publishedSignals ?? 0 }}
        </p>
    </div>

    <div class="bg-white rounded-xl shadow p-6">
        <h3 class="text-gray-500 text-sm">Guardian Accounts</h3>
        <p class="text-3xl font-bold mt-2 text-blue-600">
            {{ $guardianAccounts ?? 0 }}
        </p>
    </div>

    <div class="bg-white rounded-xl shadow p-6">
        <h3 class="text-gray-500 text-sm">Registered Users</h3>
        <p class="text-3xl font-bold mt-2 text-purple-600">
            {{ $users ?? 0 }}
        </p>
    </div>

</div>

<div class="mt-8 bg-white rounded-xl shadow p-6">

    <h2 class="text-xl font-semibold mb-4">
        Welcome to Tradewisser Admin
    </h2>

    <p class="text-gray-600">
        From this dashboard you will manage trading signals,
        market news, Guardian accounts, users, education,
        subscriptions and platform analytics.
    </p>

</div>

@endsection

