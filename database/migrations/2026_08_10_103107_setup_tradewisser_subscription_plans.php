<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        /*
        |--------------------------------------------------------------------------
        | Update Existing Premium Plan
        |--------------------------------------------------------------------------
        */

        DB::table('plans')
            ->where('id', 2)
            ->update([
                'name' => 'Premium',
                'slug' => 'premium',
                'price' => 19.99,
                'currency' => 'USD',
                'billing_cycle' => 'monthly',
                'is_active' => true,
                'sort_order' => 2,
                'updated_at' => now(),
            ]);

        /*
        |--------------------------------------------------------------------------
        | Update Existing Prop Firm Plan
        |--------------------------------------------------------------------------
        */

        DB::table('plans')
            ->where('id', 3)
            ->update([
                'name' => 'Prop Firm',
                'slug' => 'pro',
                'price' => 29.99,
                'currency' => 'USD',
                'billing_cycle' => 'monthly',
                'is_active' => true,
                'sort_order' => 3,
                'updated_at' => now(),
            ]);

        /*
        |--------------------------------------------------------------------------
        | Create Additional Premium Plans
        |--------------------------------------------------------------------------
        */

        $premiumPlans = [
            [
                'name' => 'Premium',
                'slug' => 'premium-three-months',
                'price' => 49.99,
                'billing_cycle' => 'three_months',
                'sort_order' => 4,
            ],
            [
                'name' => 'Premium',
                'slug' => 'premium-yearly',
                'price' => 99.99,
                'billing_cycle' => 'yearly',
                'sort_order' => 5,
            ],
            [
                'name' => 'Premium',
                'slug' => 'premium-two-year',
                'price' => 199.99,
                'billing_cycle' => 'two_year',
                'sort_order' => 6,
            ],
        ];

        /*
        |--------------------------------------------------------------------------
        | Create Additional Prop Firm Plans
        |--------------------------------------------------------------------------
        */

        $propFirmPlans = [
            [
                'name' => 'Prop Firm',
                'slug' => 'prop-firm-three-months',
                'price' => 79.99,
                'billing_cycle' => 'three_months',
                'sort_order' => 7,
            ],
            [
                'name' => 'Prop Firm',
                'slug' => 'prop-firm-yearly',
                'price' => 199.99,
                'billing_cycle' => 'yearly',
                'sort_order' => 8,
            ],
            [
                'name' => 'Prop Firm',
                'slug' => 'prop-firm-two-year',
                'price' => 499.99,
                'billing_cycle' => 'two_year',
                'sort_order' => 9,
            ],
        ];

        /*
        |--------------------------------------------------------------------------
        | Insert Additional Plans
        |--------------------------------------------------------------------------
        */

        $now = now();

        foreach (
            array_merge($premiumPlans, $propFirmPlans)
            as $plan
        ) {
            DB::table('plans')->insert([
                'name' => $plan['name'],
                'slug' => $plan['slug'],
                'description' => $plan['name'] === 'Premium'
                    ? 'Premium trading experience.'
                    : 'Professional trading experience for prop firm traders.',
                'price' => $plan['price'],
                'currency' => 'USD',
                'billing_cycle' => $plan['billing_cycle'],
                'is_active' => true,
                'sort_order' => $plan['sort_order'],
                'created_at' => $now,
                'updated_at' => $now,
            ]);
        }

        /*
        |--------------------------------------------------------------------------
        | Copy Premium Features
        |--------------------------------------------------------------------------
        */

        $premiumFeatureIds = DB::table('plan_features')
            ->where('plan_id', 2)
            ->pluck('feature');

        $premiumPlanIds = DB::table('plans')
            ->whereIn('slug', [
                'premium-three-months',
                'premium-yearly',
                'premium-two-year',
            ])
            ->pluck('id');

        foreach ($premiumPlanIds as $planId) {
            foreach ($premiumFeatureIds as $feature) {
                $source = DB::table('plan_features')
                    ->where('plan_id', 2)
                    ->where('feature', $feature)
                    ->first();

                DB::table('plan_features')->insert([
                    'plan_id' => $planId,
                    'feature' => $source->feature,
                    'enabled' => $source->enabled,
                    'value' => $source->value,
                    'created_at' => $now,
                    'updated_at' => $now,
                ]);
            }
        }

        /*
        |--------------------------------------------------------------------------
        | Copy Prop Firm Features
        |--------------------------------------------------------------------------
        */

        $propFirmFeatureIds = DB::table('plan_features')
            ->where('plan_id', 3)
            ->pluck('feature');

        $propFirmPlanIds = DB::table('plans')
            ->whereIn('slug', [
                'prop-firm-three-months',
                'prop-firm-yearly',
                'prop-firm-two-year',
            ])
            ->pluck('id');

        foreach ($propFirmPlanIds as $planId) {
            foreach ($propFirmFeatureIds as $feature) {
                $source = DB::table('plan_features')
                    ->where('plan_id', 3)
                    ->where('feature', $feature)
                    ->first();

                DB::table('plan_features')->insert([
                    'plan_id' => $planId,
                    'feature' => $source->feature,
                    'enabled' => $source->enabled,
                    'value' => $source->value,
                    'created_at' => $now,
                    'updated_at' => $now,
                ]);
            }
        }
    }

    public function down(): void
    {
        /*
        |--------------------------------------------------------------------------
        | Remove Additional Premium Plans
        |--------------------------------------------------------------------------
        */

        $additionalPlanIds = DB::table('plans')
            ->whereIn('slug', [
                'premium-three-months',
                'premium-yearly',
                'premium-two-year',
                'prop-firm-three-months',
                'prop-firm-yearly',
                'prop-firm-two-year',
            ])
            ->pluck('id');

        DB::table('plan_features')
            ->whereIn('plan_id', $additionalPlanIds)
            ->delete();

        DB::table('plans')
            ->whereIn('id', $additionalPlanIds)
            ->delete();

        /*
        |--------------------------------------------------------------------------
        | Restore Original Premium Plan
        |--------------------------------------------------------------------------
        */

        DB::table('plans')
            ->where('id', 2)
            ->update([
                'name' => 'Premium',
                'slug' => 'premium',
                'price' => 29.99,
                'currency' => 'USD',
                'billing_cycle' => 'monthly',
                'sort_order' => 2,
                'updated_at' => now(),
            ]);

        /*
        |--------------------------------------------------------------------------
        | Restore Original Prop Firm Plan
        |--------------------------------------------------------------------------
        */

        DB::table('plans')
            ->where('id', 3)
            ->update([
                'name' => 'Pro',
                'slug' => 'pro',
                'price' => 79.99,
                'currency' => 'USD',
                'billing_cycle' => 'monthly',
                'sort_order' => 3,
                'updated_at' => now(),
            ]);
    }
};