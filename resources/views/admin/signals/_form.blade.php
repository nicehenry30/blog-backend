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
     SIGNAL ACCESS
=========================== --}}

<div class="bg-white rounded-xl shadow p-6 mt-8">

    <h2 class="text-xl font-semibold mb-6">
        Signal Access
    </h2>

    <div>

        <label class="block font-medium mb-4">
            Who can view this signal?
        </label>

        <div class="space-y-3">

            <label class="flex items-center gap-3">

                <input
                    type="radio"
                    name="visibility"
                    value="free"
                    {{ old('visibility', $signal->visibility ?? 'free') == 'free' ? 'checked' : '' }}
                >

                <div>

                    <div class="font-medium">
                        Free
                    </div>

                    <div class="text-sm text-gray-500">
                        Visible to every registered Tradewisser user.
                    </div>

                </div>

            </label>

            <label class="flex items-center gap-3">

                <input
                    type="radio"
                    name="visibility"
                    value="premium"
                    {{ old('visibility', $signal->visibility ?? '') == 'premium' ? 'checked' : '' }}
                >

                <div>

                    <div class="font-medium">
                        Premium
                    </div>

                    <div class="text-sm text-gray-500">
                        Visible to Premium and Pro subscribers.
                    </div>

                </div>

            </label>

            <label class="flex items-center gap-3">

                <input
                    type="radio"
                    name="visibility"
                    value="pro"
                    {{ old('visibility', $signal->visibility ?? '') == 'pro' ? 'checked' : '' }}
                >

                <div>

                    <div class="font-medium">
                        Pro
                    </div>

                    <div class="text-sm text-gray-500">
                        Visible only to Pro subscribers.
                    </div>

                </div>

            </label>

        </div>

        @error('visibility')
            <p class="text-red-500 text-sm mt-2">
                {{ $message }}
            </p>
        @enderror

    </div>

</div>

{{-- ===========================
     AUTO TRADING
=========================== --}}

<div class="bg-white rounded-xl shadow p-6 mt-8">

    <h2 class="text-xl font-semibold mb-6">
        Auto Trading
    </h2>

    <div>

        <label class="block font-medium mb-4">
            Execution Mode
        </label>

        <div class="space-y-4">

            {{-- Monitor Only --}}
            <label class="flex items-start gap-3">

                <input
                    type="radio"
                    name="auto_executable"
                    value="0"
                    class="mt-1"
                    {{ old('auto_executable', $signal->auto_executable ?? 0) == 0 ? 'checked' : '' }}
                >

                <div>

                    <div class="font-medium">
                        Monitor Only
                    </div>

                    <div class="text-sm text-gray-500">
                        Guardian will receive and monitor this signal,
                        but will NOT open a trade automatically.
                    </div>

                </div>

            </label>


            {{-- Auto Execute --}}
            <label class="flex items-start gap-3">

                <input
                    type="radio"
                    name="auto_executable"
                    value="1"
                    class="mt-1"
                    {{ old('auto_executable', $signal->auto_executable ?? 0) == 1 ? 'checked' : '' }}
                >

                <div>

                    <div class="font-medium">
                        Auto Execute
                    </div>

                    <div class="text-sm text-gray-500">
                        Guardian is authorized to automatically execute
                        this signal on the connected MT4 account.
                    </div>

                </div>

            </label>

        </div>

        @error('auto_executable')
            <p class="text-red-500 text-sm mt-2">
                {{ $message }}
            </p>
        @enderror

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

        {{-- Entry Price --}}
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

        {{-- Stop Loss --}}
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

        {{-- Take Profit 1 --}}
        <div>

            <label class="block font-medium mb-2">
                Take Profit 1
            </label>

            <input
                type="number"
                step="0.00001"
                name="take_profit"
                value="{{ old('take_profit', $signal->take_profit ?? '') }}"
                class="w-full border rounded-lg px-4 py-3">

        </div>

        {{-- Take Profit 2 --}}
        <div>

            <label class="block font-medium mb-2">
                Take Profit 2 (Optional)
            </label>

            <input
                type="number"
                step="0.00001"
                name="take_profit_2"
                value="{{ old('take_profit_2', $signal->take_profit_2 ?? '') }}"
                class="w-full border rounded-lg px-4 py-3">

        </div>

        {{-- Take Profit 3 --}}
        <div>

            <label class="block font-medium mb-2">
                Take Profit 3 (Optional)
            </label>

            <input
                type="number"
                step="0.00001"
                name="take_profit_3"
                value="{{ old('take_profit_3', $signal->take_profit_3 ?? '') }}"
                class="w-full border rounded-lg px-4 py-3">

        </div>

    </div>

</div>
{{-- ===========================
     ANALYSIS
=========================== --}}

{{-- ===========================
     ANALYSIS
=========================== --}}

<div class="bg-white rounded-xl shadow p-6 mt-8">

    <h2 class="text-xl font-semibold mb-6">
        Analysis
    </h2>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

        {{-- Signal Quality --}}
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


        {{-- Overall Confidence --}}
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


        {{-- Strategy --}}
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


        {{-- Market Analysis --}}
        <div class="md:col-span-2">

            <label class="block font-medium mb-2">
                Market Analysis
            </label>

            <textarea
                name="analysis"
                rows="5"
                class="w-full border rounded-lg px-4 py-3"
                placeholder="Enter your market analysis...">{{ old('analysis', $signal->analysis ?? '') }}</textarea>

            @error('analysis')
                <p class="text-red-500 text-sm mt-2">
                    {{ $message }}
                </p>
            @enderror

        </div>


        {{-- AI Score --}}
        <div>

            <label class="block font-medium mb-2">
                AI Score (%)
            </label>

            <input
                type="number"
                min="0"
                max="100"
                name="ai_score"
                value="{{ old('ai_score', $signal->ai_score ?? '') }}"
                class="w-full border rounded-lg px-4 py-3"
                placeholder="0 - 100">

            @error('ai_score')
                <p class="text-red-500 text-sm mt-2">
                    {{ $message }}
                </p>
            @enderror

        </div>


        {{-- AI Comment --}}
        <div>

            <label class="block font-medium mb-2">
                AI Comment
            </label>

            <textarea
                name="ai_comment"
                rows="3"
                class="w-full border rounded-lg px-4 py-3"
                placeholder="AI confirmation or explanation...">{{ old('ai_comment', $signal->ai_comment ?? '') }}</textarea>

            @error('ai_comment')
                <p class="text-red-500 text-sm mt-2">
                    {{ $message }}
                </p>
            @enderror

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