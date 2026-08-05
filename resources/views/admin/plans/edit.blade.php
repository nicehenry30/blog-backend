@extends('layouts.app')

@section('title', 'Edit Plan')

@section('content')

<div class="max-w-4xl mx-auto">

    <h2 class="text-2xl font-bold mb-6">
        Edit Subscription Plan
    </h2>

    <div class="bg-white rounded-xl shadow p-6">

        <form
            action="{{ route('admin.plans.update', $plan) }}"
            method="POST"
        >

            @method('PUT')

            @include('admin.plans._form')

        </form>

    </div>

</div>

@endsection