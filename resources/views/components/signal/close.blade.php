@extends('layouts.app')

@section('title', 'Close Signal')

@section('content')

<div class="space-y-6">

    <div class="flex items-center justify-between">

        <div>

            <h1 class="text-3xl font-bold">
                Close Trading Signal
            </h1>

            <p class="text-gray-500 mt-2">
                Record the final outcome of this trading signal.
            </p>

        </div>

        <a href="{{ route('admin.signals.show', $signal) }}">

            <x-admin.button type="secondary">

                ← Back

            </x-admin.button>

        </a>

    </div>

    <x-admin.card title="Signal Result">

        <form
            method="POST"
            action="{{ route('admin.signals.close', $signal) }}"
            class="space-y-6"
        >

            @csrf
            @method('PATCH')

            <div>

                <label class="block font-medium mb-2">

                    Result

                </label>

                <select
                    name="result"
                    class="w-full border rounded-lg px-4 py-3"
                    required
                >

                    <option value="win">

                        Win

                    </option>

                    <option value="loss">

                        Loss

                    </option>

                    <option value="breakeven">

                        Breakeven

                    </option>

                </select>

            </div>

            <div>

                <label class="block font-medium mb-2">

                    Pips

                </label>

                <input
                    type="number"
                    name="pips"
                    class="w-full border rounded-lg px-4 py-3"
                    placeholder="Example: 120 or -35"
                    required
                >

            </div>

            <div>

                <label class="block font-medium mb-2">

                    Notes (Optional)

                </label>

                <textarea
                    rows="4"
                    name="notes"
                    class="w-full border rounded-lg px-4 py-3"
                    placeholder="Additional comments..."
                ></textarea>

            </div>

            <div class="flex justify-end gap-3">

                <a href="{{ route('admin.signals.show', $signal) }}">

                    <x-admin.button type="secondary">

                        Cancel

                    </x-admin.button>

                </a>

                <x-admin.button type="danger">

                    Close Signal

                </x-admin.button>

            </div>

        </form>

    </x-admin.card>

</div>

@endsection