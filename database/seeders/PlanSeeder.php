<?php

namespace Database\Seeders;

use App\Models\Plan;
use App\Models\PlanFeature;
use Illuminate\Database\Seeder;

class PlanSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $free = Plan::updateOrCreate(
            ['slug' => 'free'],
            [
                'name' => 'Free',
                'description' => 'Basic trading experience.',
                'price' => 0,
                'currency' => 'USD',
                'billing_cycle' => 'monthly',
                'is_active' => true,
                'sort_order' => 1,
            ]
        );

        $premium = Plan::updateOrCreate(
            ['slug' => 'premium'],
            [
                'name' => 'Premium',
                'description' => 'Professional trading experience.',
                'price' => 29.99,
                'currency' => 'USD',
                'billing_cycle' => 'monthly',
                'is_active' => true,
                'sort_order' => 2,
            ]
        );

        $pro = Plan::updateOrCreate(
            ['slug' => 'pro'],
            [
                'name' => 'Pro',
                'description' => 'Institutional trading experience.',
                'price' => 79.99,
                'currency' => 'USD',
                'billing_cycle' => 'monthly',
                'is_active' => true,
                'sort_order' => 3,
            ]
        );

        $this->syncFeatures($free, [

            PlanFeature::VIEW_FREE_SIGNALS => ['enabled' => true],

            PlanFeature::VIEW_PREMIUM_SIGNALS => ['enabled' => false],

            PlanFeature::VIEW_PRO_SIGNALS => ['enabled' => false],

            PlanFeature::DAILY_SIGNAL_LIMIT => [
                'enabled' => true,
                'value' => '2',
            ],

            PlanFeature::SIGNAL_HISTORY => [
                'enabled' => true,
            ],

            PlanFeature::TP_TRACKING => [
                'enabled' => true,
            ],

            PlanFeature::BASIC_COURSES => [
                'enabled' => true,
            ],

            PlanFeature::PREMIUM_COURSES => [
                'enabled' => false,
            ],

            PlanFeature::JOURNAL => [
                'enabled' => true,
            ],

            PlanFeature::JOURNAL_LIMIT => [
                'enabled' => true,
                'value' => '20',
            ],

            PlanFeature::GUARDIAN_MT4 => [
                'enabled' => false,
            ],

            PlanFeature::GUARDIAN_MT5 => [
                'enabled' => false,
            ],

            PlanFeature::PUSH_NOTIFICATIONS => [
                'enabled' => false,
            ],

        ]);

        $this->syncFeatures($premium, [

            PlanFeature::VIEW_FREE_SIGNALS => ['enabled' => true],

            PlanFeature::VIEW_PREMIUM_SIGNALS => ['enabled' => true],

            PlanFeature::VIEW_PRO_SIGNALS => ['enabled' => false],

            PlanFeature::DAILY_SIGNAL_LIMIT => [
                'enabled' => true,
                'value' => 'unlimited',
            ],

            PlanFeature::SIGNAL_HISTORY => [
                'enabled' => true,
            ],

            PlanFeature::TP_TRACKING => [
                'enabled' => true,
            ],

            PlanFeature::BASIC_COURSES => [
                'enabled' => true,
            ],

            PlanFeature::PREMIUM_COURSES => [
                'enabled' => true,
            ],

            PlanFeature::JOURNAL => [
                'enabled' => true,
            ],

            PlanFeature::JOURNAL_LIMIT => [
                'enabled' => true,
                'value' => 'unlimited',
            ],

            PlanFeature::GUARDIAN_MT4 => [
                'enabled' => true,
            ],

            PlanFeature::GUARDIAN_MT5 => [
                'enabled' => true,
            ],

            PlanFeature::GUARDIAN_ACCOUNTS => [
                'enabled' => true,
                'value' => '1',
            ],

            PlanFeature::PUSH_NOTIFICATIONS => [
                'enabled' => true,
            ],

            PlanFeature::EMAIL_NOTIFICATIONS => [
                'enabled' => true,
            ],

        ]);

        $this->syncFeatures($pro, [

            PlanFeature::VIEW_FREE_SIGNALS => ['enabled' => true],

            PlanFeature::VIEW_PREMIUM_SIGNALS => ['enabled' => true],

            PlanFeature::VIEW_PRO_SIGNALS => ['enabled' => true],

            PlanFeature::DAILY_SIGNAL_LIMIT => [
                'enabled' => true,
                'value' => 'unlimited',
            ],

            PlanFeature::SIGNAL_HISTORY => [
                'enabled' => true,
            ],

            PlanFeature::TP_TRACKING => [
                'enabled' => true,
            ],

            PlanFeature::BASIC_COURSES => [
                'enabled' => true,
            ],

            PlanFeature::PREMIUM_COURSES => [
                'enabled' => true,
            ],

            PlanFeature::JOURNAL => [
                'enabled' => true,
            ],

            PlanFeature::JOURNAL_LIMIT => [
                'enabled' => true,
                'value' => 'unlimited',
            ],

            PlanFeature::GUARDIAN_MT4 => [
                'enabled' => true,
            ],

            PlanFeature::GUARDIAN_MT5 => [
                'enabled' => true,
            ],

            PlanFeature::GUARDIAN_ACCOUNTS => [
                'enabled' => true,
                'value' => '10',
            ],

            PlanFeature::AI_SIGNAL_ANALYSIS => [
                'enabled' => true,
            ],

            PlanFeature::AI_TRADING_COACH => [
                'enabled' => true,
            ],

            PlanFeature::AI_REQUEST_LIMIT => [
                'enabled' => true,
                'value' => '1000',
            ],

            PlanFeature::PUSH_NOTIFICATIONS => [
                'enabled' => true,
            ],

            PlanFeature::EMAIL_NOTIFICATIONS => [
                'enabled' => true,
            ],

            PlanFeature::PRIORITY_SUPPORT => [
                'enabled' => true,
            ],

        ]);
    }

    /**
     * Synchronize plan features.
     */
    private function syncFeatures(Plan $plan, array $features): void
    {
        foreach ($features as $feature => $config) {

            $plan->features()->updateOrCreate(
                [
                    'feature' => $feature,
                ],
                [
                    'enabled' => $config['enabled'],
                    'value' => $config['value'] ?? null,
                ]
            );

        }
    }
}