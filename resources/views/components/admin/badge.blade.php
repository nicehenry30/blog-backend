@props([
    'status',
])

@php

$color = match($status) {

    'Draft'      => 'bg-gray-100 text-gray-700',

    'Pending'    => 'bg-yellow-100 text-yellow-700',

    'Approved'   => 'bg-blue-100 text-blue-700',

    'Published'  => 'bg-green-100 text-green-700',

    'Running'    => 'bg-indigo-100 text-indigo-700',

    'TP1 Hit'    => 'bg-cyan-100 text-cyan-700',

    'TP2 Hit'    => 'bg-sky-100 text-sky-700',

    'TP3 Hit'    => 'bg-emerald-100 text-emerald-700',

    'Closed'     => 'bg-purple-100 text-purple-700',

    'Rejected'   => 'bg-red-100 text-red-700',

    'Cancelled'  => 'bg-red-100 text-red-700',

    'Expired'    => 'bg-orange-100 text-orange-700',

    default      => 'bg-gray-100 text-gray-700',

};

@endphp

<span class="px-3 py-1 rounded-full text-sm font-medium {{ $color }}">

    {{ $status }}

</span>