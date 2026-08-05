<?php

namespace Database\Seeders;

use App\Models\Plan;
use App\Models\PlanFeature;
use Illuminate\Database\Seeder;

class PlanSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        /*
        |--------------------------------------------------------------------------
        | FREE PLAN
        |--------------------------------------------------------------------------
        */

        $free = Plan::create([
            'name' => 'Free',
            'slug' => 'free',
            'description' => 'Basic trading experience.',
            'price' => 0,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $this->addFeatures($free, [
            PlanFeature::DELAYED_SIGNALS,
            PlanFeature::JOURNAL,
            PlanFeature::DASHBOARD,
        ]);

        /*
        |--------------------------------------------------------------------------
        | PREMIUM PLAN
        |--------------------------------------------------------------------------
        */

        $premium = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium',
            'description' => 'Professional trading plan.',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 2,
        ]);

        $this->addFeatures($premium, [
            PlanFeature::LIVE_SIGNALS,
            PlanFeature::JOURNAL,
            PlanFeature::DASHBOARD,
            PlanFeature::EDUCATION,
            PlanFeature::PUSH_NOTIFICATIONS,
        ]);

        /*
        |--------------------------------------------------------------------------
        | PRO PLAN
        |--------------------------------------------------------------------------
        */

        $pro = Plan::create([
            'name' => 'Pro',
            'slug' => 'pro',
            'description' => 'Complete institutional trading experience.',
            'price' => 79.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 3,
        ]);

        $this->addFeatures($pro, [
            PlanFeature::LIVE_SIGNALS,
            PlanFeature::JOURNAL,
            PlanFeature::DASHBOARD,
            PlanFeature::EDUCATION,
            PlanFeature::PUSH_NOTIFICATIONS,
            PlanFeature::GUARDIAN,
            PlanFeature::AI_COACH,
            PlanFeature::PRIORITY_SUPPORT,
        ]);
    }

    /**
     * Attach features to a plan.
     */
    private function addFeatures(Plan $plan, array $features): void
    {
        foreach ($features as $feature) {
            $plan->features()->create([
                'feature' => $feature,
                'enabled' => true,
            ]);
        }
    }
}