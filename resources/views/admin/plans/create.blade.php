@extends('layouts.app')

@section('title', 'Create Plan')

@section('content')

<div class="max-w-4xl mx-auto">

    <h2 class="text-2xl font-bold mb-6">
        Create Subscription Plan
    </h2>

    <div class="bg-white rounded-xl shadow p-6">

        <form
            action="{{ route('admin.plans.store') }}"
            method="POST"
        >

            @include('admin.plans._form')

        </form>

    </div>

</div>

@endsection