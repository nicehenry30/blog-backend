@props([
    'variant' => 'primary',
])

@php

$classes = match($variant) {

    'primary' =>
        'bg-blue-600 hover:bg-blue-700 text-white',

    'success' =>
        'bg-green-600 hover:bg-green-700 text-white',

    'danger' =>
        'bg-red-600 hover:bg-red-700 text-white',

    'warning' =>
        'bg-yellow-500 hover:bg-yellow-600 text-white',

    'secondary' =>
        'bg-gray-200 hover:bg-gray-300 text-gray-800',

    default =>
        'bg-blue-600 hover:bg-blue-700 text-white',

};

@endphp

<button
    {{ $attributes->merge([
        'type' => 'submit',
        'class' => "px-5 py-2 rounded-lg font-medium transition $classes",
    ]) }}
>

    {{ $slot }}

</button>