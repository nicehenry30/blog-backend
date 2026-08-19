@php

use App\Models\Signal;

$colors = [

    Signal::STATUS_DRAFT => 'bg-gray-100 text-gray-700',

    Signal::STATUS_APPROVED => 'bg-blue-100 text-blue-700',

    Signal::STATUS_PUBLISHED => 'bg-green-100 text-green-700',

    Signal::STATUS_RUNNING => 'bg-purple-100 text-purple-700',

    Signal::STATUS_CLOSED => 'bg-emerald-100 text-emerald-700',

    Signal::STATUS_REJECTED => 'bg-red-100 text-red-700',

    Signal::STATUS_CANCELLED => 'bg-red-100 text-red-700',

    Signal::STATUS_EXPIRED => 'bg-slate-100 text-slate-700',

];

@endphp

<span
    class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold {{ $colors[$status] ?? 'bg-gray-100 text-gray-700' }}"
>
    {{ $status }}
</span>