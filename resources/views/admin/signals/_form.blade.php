{{-- ===========================
     MARKET INFORMATION
=========================== --}}

<div class="bg-white rounded-xl shadow p-6">

    <h2 class="text-xl font-semibold mb-6">
        Market Information
    </h2>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

        {{-- Trading Symbol --}}
        <div>

            <label class="block font-medium mb-2">
                Trading Symbol
            </label>

            <select
                name="symbol_id"
                class="w-full border rounded-lg px-4 py-3"
                required>

                <option value="">
                    Select Trading Symbol
                </option>

                @foreach($symbols as $assetType => $items)

                    <optgroup label="{{ $assetType }}">

                        @foreach($items as $symbol)

                            <option
                                value="{{ $symbol->id }}"
                                @selected(old('symbol_id', $signal->symbol_id ?? '') == $symbol->id)>

                                {{ $symbol->symbol }} — {{ $symbol->name }}

                            </option>

                        @endforeach

                    </optgroup>

                @endforeach

            </select>

            @error('symbol_id')
                <p class="text-red-500 text-sm mt-2">
                    {{ $message }}
                </p>
            @enderror

        </div>

        {{-- Direction --}}
        <div>

            <label class="block font-medium mb-2">
                Direction
            </label>

            <select
                name="direction"
                class="w-full border rounded-lg px-4 py-3">

                <option value="BUY"
                    @selected(old('direction', $signal->direction ?? '') == 'BUY')>
                    BUY
                </option>

                <option value="SELL"
                    @selected(old('direction', $signal->direction ?? '') == 'SELL')>
                    SELL
                </option>

            </select>

        </div>

        {{-- Timeframe --}}
        <div>

            <label class="block font-medium mb-2">
                Timeframe
            </label>

            <select
                name="timeframe"
                class="w-full border rounded-lg px-4 py-3">

                @foreach([
                    'M5',
                    'M15',
                    'M30',
                    'H1',
                    'H4',
                    'D1',
                    'W1'
                ] as $tf)

                    <option
                        value="{{ $tf }}"
                        @selected(old('timeframe', $signal->timeframe ?? '') == $tf)>

                        {{ $tf }}

                    </option>

                @endforeach

            </select>

        </div>

    </div>

</div>

{{-- ===========================
     TRADE SETUP
=========================== --}}

<div class="bg-white rounded-xl shadow p-6 mt-8">

    <h2 class="text-xl font-semibold mb-6">
        Trade Setup
    </h2>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

        <div>

            <label class="block font-medium mb-2">
                Entry Price
            </label>

            <input
                type="number"
                step="0.00001"
                name="entry_price"
                value="{{ old('entry_price', $signal->entry_price ?? '') }}"
                class="w-full border rounded-lg px-4 py-3">

            @error('entry_price')
                <p class="text-red-500 text-sm mt-2">
                    {{ $message }}
                </p>
            @enderror

        </div>

        <div>

            <label class="block font-medium mb-2">
                Stop Loss
            </label>

            <input
                type="number"
                step="0.00001"
                name="stop_loss"
                value="{{ old('stop_loss', $signal->stop_loss ?? '') }}"
                class="w-full border rounded-lg px-4 py-3">

            @error('stop_loss')
                <p class="text-red-500 text-sm mt-2">
                    {{ $message }}
                </p>
            @enderror

        </div>

        <div>

            <label class="block font-medium mb-2">
                Take Profit
            </label>

            <input
                type="number"
                step="0.00001"
                name="take_profit"
                value="{{ old('take_profit', $signal->take_profit ?? '') }}"
                class="w-full border rounded-lg px-4 py-3">

            @error('take_profit')
                <p class="text-red-500 text-sm mt-2">
                    {{ $message }}
                </p>
            @enderror

        </div>

    </div>

</div>
{{-- ===========================
     ANALYSIS
=========================== --}}

<div class="bg-white rounded-xl shadow p-6 mt-8">

    <h2 class="text-xl font-semibold mb-6">
        Analysis
    </h2>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

        <div>

            <label class="block font-medium mb-2">
                Signal Quality (%)
            </label>

            <input
                type="number"
                min="0"
                max="100"
                name="signal_quality"
                value="{{ old('signal_quality', $signal->signal_quality ?? '') }}"
                class="w-full border rounded-lg px-4 py-3">

            @error('signal_quality')
                <p class="text-red-500 text-sm mt-2">
                    {{ $message }}
                </p>
            @enderror

        </div>

        <div>

            <label class="block font-medium mb-2">
                Overall Confidence (%)
            </label>

            <input
                type="number"
                min="0"
                max="100"
                name="overall_confidence"
                value="{{ old('overall_confidence', $signal->overall_confidence ?? '') }}"
                class="w-full border rounded-lg px-4 py-3">

            @error('overall_confidence')
                <p class="text-red-500 text-sm mt-2">
                    {{ $message }}
                </p>
            @enderror

        </div>

        <div class="md:col-span-2">

            <label class="block font-medium mb-2">
                Strategy
            </label>

            <input
                type="text"
                name="strategy"
                value="{{ old('strategy', $signal->strategy ?? '') }}"
                class="w-full border rounded-lg px-4 py-3"
                placeholder="ICT, SMC, Breakout...">

        </div>

    </div>

</div>

{{-- ===========================
     ADDITIONAL INFORMATION
=========================== --}}

<div class="bg-white rounded-xl shadow p-6 mt-8">

    <h2 class="text-xl font-semibold mb-6">
        Additional Information
    </h2>

    @php
        $selectedConfluences = old(
            'confluences',
            $signal->confluences ?? []
        );
    @endphp

    <div class="space-y-6">

        <div>

            <label class="block font-medium mb-2">
                Confluences
            </label>

            <div class="grid grid-cols-2 md:grid-cols-3 gap-3">

                @foreach([
                    'Market Structure',
                    'Order Block',
                    'Liquidity Sweep',
                    'Fair Value Gap',
                    'Breaker Block',
                    'Supply Zone',
                    'Demand Zone',
                    'EMA',
                    'Trendline',
                    'Support',
                    'Resistance',
                    'RSI',
                    'MACD',
                    'ATR',
                    'Bollinger Bands'
                ] as $item)

                    <label class="flex items-center gap-2">

                        <input
                            type="checkbox"
                            name="confluences[]"
                            value="{{ $item }}"
                            {{ in_array($item, $selectedConfluences) ? 'checked' : '' }}>

                        <span>{{ $item }}</span>

                    </label>

                @endforeach

            </div>

        </div>

        <div>

            <label class="block font-medium mb-2">
                Chart Image
            </label>

            @if(!empty($signal?->chart_image))

                <div class="mb-4">

                    <img
                        src="{{ asset('storage/'.$signal->chart_image) }}"
                        class="w-56 rounded-lg border">

                </div>

            @endif

            <input
                type="file"
                name="chart_image"
                accept=".jpg,.jpeg,.png,.webp"
                class="w-full border rounded-lg px-4 py-3">

            @error('chart_image')
                <p class="text-red-500 text-sm mt-2">
                    {{ $message }}
                </p>
            @enderror

        </div>

    </div>

</div>