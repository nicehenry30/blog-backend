@csrf

<div class="space-y-6">

    <div>

        <label class="block mb-2 font-medium">
            Plan Name
        </label>

        <input
            type="text"
            name="name"
            value="{{ old('name', $plan->name ?? '') }}"
            class="w-full border rounded-lg px-4 py-3"
            required
        >

    </div>

    <div>

        <label class="block mb-2 font-medium">
            Slug
        </label>

        <input
            type="text"
            name="slug"
            value="{{ old('slug', $plan->slug ?? '') }}"
            class="w-full border rounded-lg px-4 py-3"
            required
        >

    </div>

    <div>

        <label class="block mb-2 font-medium">
            Description
        </label>

        <textarea
            name="description"
            rows="4"
            class="w-full border rounded-lg px-4 py-3"
        >{{ old('description', $plan->description ?? '') }}</textarea>

    </div>

    <div class="grid grid-cols-2 gap-6">

        <div>

            <label class="block mb-2 font-medium">
                Price
            </label>

            <input
                type="number"
                step="0.01"
                name="price"
                value="{{ old('price', $plan->price ?? 0) }}"
                class="w-full border rounded-lg px-4 py-3"
                required
            >

        </div>

        <div>

            <label class="block mb-2 font-medium">
                Currency
            </label>

            <input
                type="text"
                name="currency"
                value="{{ old('currency', $plan->currency ?? 'USD') }}"
                class="w-full border rounded-lg px-4 py-3"
                required
            >

        </div>

    </div>

    <div class="grid grid-cols-2 gap-6">

        <div>

            <label class="block mb-2 font-medium">
                Billing Cycle
            </label>

            <select
                name="billing_cycle"
                class="w-full border rounded-lg px-4 py-3"
            >
                <option value="monthly"
                    @selected(old('billing_cycle', $plan->billing_cycle ?? '') == 'monthly')>
                    Monthly
                </option>

                <option value="yearly"
                    @selected(old('billing_cycle', $plan->billing_cycle ?? '') == 'yearly')>
                    Yearly
                </option>

                <option value="lifetime"
                    @selected(old('billing_cycle', $plan->billing_cycle ?? '') == 'lifetime')>
                    Lifetime
                </option>
            </select>

        </div>

        <div>

            <label class="block mb-2 font-medium">
                Sort Order
            </label>

            <input
                type="number"
                name="sort_order"
                value="{{ old('sort_order', $plan->sort_order ?? 1) }}"
                class="w-full border rounded-lg px-4 py-3"
                required
            >

        </div>

    </div>

    <div>

        <label class="inline-flex items-center">

            <input
                type="checkbox"
                name="is_active"
                value="1"
                @checked(old('is_active', $plan->is_active ?? true))
            >

            <span class="ml-2">
                Active Plan
            </span>

        </label>

    </div>

    <button
        type="submit"
        class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg"
    >
        Save Plan
    </button>

</div>