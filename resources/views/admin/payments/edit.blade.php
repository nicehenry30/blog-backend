@extends('layouts.app')

@section('title', 'Edit Payment')

@section('content')

<div class="max-w-4xl mx-auto">

    <h2 class="text-2xl font-bold mb-6">
        Edit Payment
    </h2>

    <div class="bg-white rounded-xl shadow p-6">

        <form
            action="{{ route('admin.payments.update', $payment) }}"
            method="POST"
        >

            @method('PUT')

            @include('admin.payments._form')

        </form>

    </div>

</div>

@endsection