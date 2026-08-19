@extends('layouts.app')

@section('title', 'Create Symbol')

@section('content')

<div class="max-w-3xl mx-auto bg-white rounded-xl shadow p-6">

    <h2 class="text-2xl font-bold mb-6">
        Create Trading Symbol
    </h2>

    <form method="POST" action="{{ route('admin.symbols.store') }}">

        @csrf

        <div class="mb-4">
            <label class="block font-medium mb-2">
                Symbol
            </label>

            <input
                type="text"
                name="symbol"
                value="{{ old('symbol') }}"
                class="w-full border rounded-lg px-4 py-3"
                required
            >
        </div>

        <div class="mb-4">
            <label class="block font-medium mb-2">
                Name
            </label>

            <input
                type="text"
                name="name"
                value="{{ old('name') }}"
                class="w-full border rounded-lg px-4 py-3"
                required
            >
        </div>

        <div class="mb-4">
            <label class="block font-medium mb-2">
                Asset Type
            </label>

            <select
                name="asset_type"
                class="w-full border rounded-lg px-4 py-3"
            >
                <option value="Forex">Forex</option>
                <option value="Metal">Metal</option>
                <option value="Crypto">Crypto</option>
                <option value="Index">Index</option>
                <option value="Commodity">Commodity</option>
                <option value="Stock">Stock</option>
                <option value="ETF">ETF</option>
                <option value="Other">Other</option>
            </select>
        </div>

        <div class="mb-4">
            <label class="block font-medium mb-2">
                Broker Symbol
            </label>

            <input
                type="text"
                name="broker_symbol"
                value="{{ old('broker_symbol') }}"
                class="w-full border rounded-lg px-4 py-3"
            >
        </div>

        <div class="mb-4">
            <label class="block font-medium mb-2">
                Digits
            </label>

            <input
                type="number"
                name="digits"
                value="{{ old('digits', 5) }}"
                class="w-full border rounded-lg px-4 py-3"
                required
            >
        </div>

        <div class="mb-6">
            <label class="inline-flex items-center">
                <input
                    type="checkbox"
                    name="active"
                    value="1"
                    checked
                    class="mr-2"
                >
                Active
            </label>
        </div>

        <div class="flex gap-3">

            <button
                type="submit"
                class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg"
            >
                Save Symbol
            </button>

            <a
                href="{{ route('admin.symbols.index') }}"
                class="px-6 py-3 border rounded-lg"
            >
                Cancel
            </a>

        </div>

    </form>

</div>

@endsection