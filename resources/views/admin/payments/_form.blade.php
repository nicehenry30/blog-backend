@csrf

<div class="space-y-6">

    <div>

        <label class="block mb-2 font-medium">
            Payment Status
        </label>

        <select
            name="status"
            class="w-full border rounded-lg px-4 py-3"
            required
        >

            <option value="pending"
                @selected(old('status', $payment->status ?? '') == 'pending')>
                Pending
            </option>

            <option value="successful"
                @selected(old('status', $payment->status ?? '') == 'successful')>
                Successful
            </option>

            <option value="failed"
                @selected(old('status', $payment->status ?? '') == 'failed')>
                Failed
            </option>

            <option value="refunded"
                @selected(old('status', $payment->status ?? '') == 'refunded')>
                Refunded
            </option>

        </select>

    </div>

    <div>

        <label class="block mb-2 font-medium">
            Reference
        </label>

        <input
            type="text"
            name="reference"
            value="{{ old('reference', $payment->reference ?? '') }}"
            class="w-full border rounded-lg px-4 py-3"
        >

    </div>

    <div>

        <label class="block mb-2 font-medium">
            Gateway Reference
        </label>

        <input
            type="text"
            name="gateway_reference"
            value="{{ old('gateway_reference', $payment->gateway_reference ?? '') }}"
            class="w-full border rounded-lg px-4 py-3"
        >

    </div>

    <button
        type="submit"
        class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg"
    >
        Save Payment
    </button>

</div>