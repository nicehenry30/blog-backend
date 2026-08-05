@extends('layouts.app')

@section('title', 'Edit Subscription')

@section('content')

<div class="max-w-4xl mx-auto">

    <h2 class="text-2xl font-bold mb-6">
        Edit Subscription
    </h2>

    <div class="bg-white rounded-xl shadow p-6">

        <form
            action="{{ route('admin.subscriptions.update', $subscription) }}"
            method="POST"
        >

            @method('PUT')

            @include('admin.subscriptions._form')

        </form>

    </div>

</div>

@endsection