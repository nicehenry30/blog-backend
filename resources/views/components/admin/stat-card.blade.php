@props([
    'title',
    'value',
    'color' => 'blue',
])

<div class="bg-white rounded-xl border border-gray-200 shadow-sm p-6">

    <div class="text-sm text-gray-500">

        {{ $title }}

    </div>

    <div class="mt-3 text-3xl font-bold text-{{ $color }}-600">

        {{ $value }}

    </div>

</div>