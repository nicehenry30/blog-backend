<div class="space-y-6">

    <div>

        <label class="block font-medium mb-2">
            Trading Symbol
        </label>

        <input
            type="text"
            name="symbol"
            value="{{ old('symbol', $symbol->symbol ?? '') }}"
            class="w-full border rounded-lg px-4 py-3"
            placeholder="XAUUSD">

        @error('symbol')
            <p class="text-red-500 mt-1">{{ $message }}</p>
        @enderror

    </div>

    <div>

        <label class="block font-medium mb-2">
            Display Name
        </label>

        <input
            type="text"
            name="name"
            value="{{ old('name', $symbol->name ?? '') }}"
            class="w-full border rounded-lg px-4 py-3"
            placeholder="Gold">

        @error('name')
            <p class="text-red-500 mt-1">{{ $message }}</p>
        @enderror

    </div>

    <div>

        <label class="block font-medium mb-2">
            Asset Type
        </label>

        <select
            name="asset_type"
            class="w-full border rounded-lg px-4 py-3">

            @php
                $types = [
                    'Forex',
                    'Metal',
                    'Crypto',
                    'Index',
                    'Commodity',
                    'Stock',
                    'ETF',
                    'Other',
                ];
            @endphp

            @foreach($types as $type)

                <option
                    value="{{ $type }}"
                    @selected(old('asset_type', $symbol->asset_type ?? '') == $type)>

                    {{ $type }}

                </option>

            @endforeach

        </select>

    </div>

    <div>

        <label class="block font-medium mb-2">
            Broker Symbol
        </label>

        <input
            type="text"
            name="broker_symbol"
            value="{{ old('broker_symbol', $symbol->broker_symbol ?? '') }}"
            class="w-full border rounded-lg px-4 py-3"
            placeholder="USTEC">

    </div>

    <div>

        <label class="block font-medium mb-2">
            Digits
        </label>

        <input
            type="number"
            name="digits"
            value="{{ old('digits', $symbol->digits ?? 5) }}"
            class="w-full border rounded-lg px-4 py-3">

    </div>

    <div class="flex items-center gap-3">

        <input
            type="checkbox"
            name="active"
            value="1"
            @checked(old('active', $symbol->active ?? true))>

        <label>

            Active

        </label>

    </div>

</div>