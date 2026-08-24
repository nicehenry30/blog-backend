<?php

namespace Tests\Feature;

use App\Models\Plan;
use App\Models\User;
use App\Services\TrialService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
use RuntimeException;
use Tests\TestCase;

class TrialServiceTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_start_seven_day_trial(): void
    {
        Carbon::setTestNow('2026-08-23 14:00:00');

        $user = User::factory()->create();

        $plan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
        ]);

        $subscription = app(TrialService::class)->startTrial(
            $user,
            $plan,
            'test',
            'payment_method_123',
        );

        $this->assertTrue($subscription->is_trial);
        $this->assertEquals('active', $subscription->status);
        $this->assertTrue($subscription->auto_renew);
        $this->assertTrue($subscription->payment_method_verified);

        $this->assertEquals(
            '2026-08-30 14:00:00',
            $subscription->trial_ends_at->format('Y-m-d H:i:s')
        );

        $this->assertEquals(
            '2026-08-30 14:00:00',
            $subscription->next_billing_at->format('Y-m-d H:i:s')
        );

        Carbon::setTestNow();
    }

    public function test_user_cannot_use_trial_twice(): void
    {
        $user = User::factory()->create();

        $plan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
        ]);

        $service = app(TrialService::class);

        $service->startTrial(
            $user,
            $plan,
            'test',
            'payment_method_123',
        );

        $this->expectException(RuntimeException::class);

        $service->startTrial(
            $user,
            $plan,
            'test',
            'payment_method_456',
        );
    }

    public function test_user_with_active_subscription_cannot_start_trial(): void
    {
        $user = User::factory()->create();

        $plan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
        ]);

        $user->subscriptions()->create([
            'plan_id' => $plan->id,
            'status' => 'active',
            'starts_at' => now(),
            'expires_at' => now()->addMonth(),
            'auto_renew' => true,
            'is_trial' => false,
            'payment_method_verified' => true,
        ]);

        $this->expectException(RuntimeException::class);

        app(TrialService::class)->startTrial(
            $user,
            $plan,
            'test',
            'payment_method_123',
        );
    }

    public function test_has_used_trial_returns_correct_value(): void
    {
        $user = User::factory()->create();

        $this->assertFalse(
            app(TrialService::class)->hasUsedTrial($user)
        );

        $plan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
        ]);

        app(TrialService::class)->startTrial(
            $user,
            $plan,
            'test',
            'payment_method_123',
        );

        $this->assertTrue(
            app(TrialService::class)->hasUsedTrial($user)
        );
    }

    public function test_trial_is_active_during_trial_period(): void
    {
        Carbon::setTestNow('2026-08-23 14:00:00');

        $user = User::factory()->create();

        $plan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
        ]);

        $service = app(TrialService::class);

        $service->startTrial(
            $user,
            $plan,
            'test',
            'payment_method_123',
        );

        $this->assertTrue(
            $service->isTrialActive($user)
        );

        Carbon::setTestNow('2026-08-30 14:00:01');

        $this->assertFalse(
            $service->isTrialActive($user)
        );

        Carbon::setTestNow();
    }
}