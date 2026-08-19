@props(['visibility'])

@php

$colors = [

    'free' => 'bg-green-100 text-green-700',

    'premium' => 'bg-blue-100 text-blue-700',

    'pro' => 'bg-purple-100 text-purple-700',

];

@endphp

<span
    class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold {{ $colors[$visibility] ?? 'bg-gray-100 text-gray-700' }}"
>
    {{ ucfirst($visibility) }}
</span>