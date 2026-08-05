@extends('layouts.app')

@section('title', 'Trading Symbols')

@section('content')

<div class="space-y-8">

    <!-- Header -->

    <div class="flex items-center justify-between">

        <div>

            <h1 class="text-3xl font-bold">
                Trading Symbols
            </h1>

            <p class="text-gray-500 mt-1">
                Manage all tradable instruments available in Tradewisser.
            </p>

        </div>

        <a
            href="{{ route('admin.symbols.create') }}"
            class="bg-blue-600 hover:bg-blue-700 text-white px-5 py-3 rounded-lg">

            + Add Symbol

        </a>

    </div>

    <!-- Table -->

    <div class="bg-white rounded-xl shadow overflow-hidden">

        <table class="min-w-full">

            <thead class="bg-gray-100">

                <tr>

                    <th class="text-left px-6 py-4">
                        Symbol
                    </th>

                    <th class="text-left px-6 py-4">
                        Name
                    </th>

                    <th class="text-left px-6 py-4">
                        Asset Type
                    </th>

                    <th class="text-center px-6 py-4">
                        Digits
                    </th>

                    <th class="text-center px-6 py-4">
                        Status
                    </th>

                    <th class="text-center px-6 py-4">
                        Actions
                    </th>

                </tr>

            </thead>

            <tbody>

                @forelse($symbols as $symbol)

                    <tr class="border-t">

                        <td class="px-6 py-4 font-semibold">

                            {{ $symbol->symbol }}

                        </td>

                        <td class="px-6 py-4">

                            {{ $symbol->name }}

                        </td>

                        <td class="px-6 py-4">

                            {{ $symbol->asset_type }}

                        </td>

                        <td class="text-center px-6 py-4">

                            {{ $symbol->digits }}

                        </td>

                        <td class="text-center px-6 py-4">

                            @if($symbol->active)

                                <span class="text-green-600 font-semibold">
                                    Active
                                </span>

                            @else

                                <span class="text-red-600 font-semibold">
                                    Inactive
                                </span>

                            @endif

                        </td>

                        <td class="text-center px-6 py-4">

                            <div class="flex justify-center gap-3">

                                <a
                                    href="{{ route('admin.symbols.edit', $symbol) }}"
                                    class="text-blue-600 hover:underline">

                                    Edit

                                </a>

                                <form
                                    action="{{ route('admin.symbols.destroy', $symbol) }}"
                                    method="POST"
                                    onsubmit="return confirm('Delete this symbol?')">

                                    @csrf
                                    @method('DELETE')

                                    <button
                                        class="text-red-600 hover:underline">

                                        Delete

                                    </button>

                                </form>

                            </div>

                        </td>

                    </tr>

                @empty

                    <tr>

                        <td
                            colspan="6"
                            class="text-center py-10 text-gray-500">

                            No trading symbols found.

                        </td>

                    </tr>

                @endforelse

            </tbody>

        </table>

    </div>

    <!-- Pagination -->

    <div>

        {{ $symbols->links() }}

    </div>

</div>

@endsection