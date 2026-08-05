@csrf

<div class="space-y-6">

    <div>

        <label class="block mb-2 font-medium">
            Subscription Plan
        </label>

        <select
            name="plan_id"
            class="w-full border rounded-lg px-4 py-3"
            required
        >

            @foreach($plans as $plan)

                <option
                    value="{{ $plan->id }}"
                    @selected(old('plan_id', $subscription->plan_id ?? '') == $plan->id)
                >
                    {{ $plan->name }}
                </option>

            @endforeach

        </select>

    </div>

    <div>

        <label class="block mb-2 font-medium">
            Status
        </label>

        <select
            name="status"
            class="w-full border rounded-lg px-4 py-3"
            required
        >

            <option value="active"
                @selected(old('status', $subscription->status ?? '') == 'active')>
                Active
            </option>

            <option value="expired"
                @selected(old('status', $subscription->status ?? '') == 'expired')>
                Expired
            </option>

            <option value="cancelled"
                @selected(old('status', $subscription->status ?? '') == 'cancelled')>
                Cancelled
            </option>

        </select>

    </div>

    <div class="grid grid-cols-2 gap-6">

        <div>

            <label class="block mb-2 font-medium">
                Starts At
            </label>

            <input
                type="date"
                name="starts_at"
                value="{{ old('starts_at', optional($subscription->starts_at)->format('Y-m-d')) }}"
                class="w-full border rounded-lg px-4 py-3"
            >

        </div>

        <div>

            <label class="block mb-2 font-medium">
                Expires At
            </label>

            <input
                type="date"
                name="expires_at"
                value="{{ old('expires_at', optional($subscription->expires_at)->format('Y-m-d')) }}"
                class="w-full border rounded-lg px-4 py-3"
            >

        </div>

    </div>

    <div>

        <label class="inline-flex items-center">

            <input
                type="checkbox"
                name="auto_renew"
                value="1"
                @checked(old('auto_renew', $subscription->auto_renew ?? false))
            >

            <span class="ml-2">
                Auto Renew
            </span>

        </label>

    </div>

    <button
        type="submit"
        class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg"
    >
        Save Subscription
    </button>

</div>