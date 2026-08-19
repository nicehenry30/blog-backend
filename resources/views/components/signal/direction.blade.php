@if($direction === 'BUY')

    <span class="inline-flex items-center px-3 py-1 rounded-full bg-green-100 text-green-700 font-semibold">
        BUY
    </span>

@else

    <span class="inline-flex items-center px-3 py-1 rounded-full bg-red-100 text-red-700 font-semibold">
        SELL
    </span>

@endif