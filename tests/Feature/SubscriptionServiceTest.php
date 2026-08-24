<?php

namespace Tests\Feature;

use App\Models\Plan;
use App\Models\Subscription;
use App\Models\User;
use App\Services\SubscriptionService;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use RuntimeException;
use Tests\TestCase;

class SubscriptionServiceTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        Carbon::setTestNow('2026-08-23 14:00:00');
    }

    protected function tearDown(): void
    {
        Carbon::setTestNow();

        parent::tearDown();
    }

    /**
     * A user can activate a paid subscription.
     */
    public function test_user_can_activate_paid_subscription(): void
    {
        $user = User::factory()->create();

        $plan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium-test',
            'description' => 'Premium test plan',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $subscription = app(SubscriptionService::class)->activateSubscription(
            $user,
            $plan
        );

        $this->assertInstanceOf(
            Subscription::class,
            $subscription
        );

        $this->assertEquals(
            $user->id,
            $subscription->user_id
        );

        $this->assertEquals(
            $plan->id,
            $subscription->plan_id
        );

        $this->assertEquals(
            'active',
            $subscription->status
        );

        $this->assertFalse(
            $subscription->is_trial
        );

        $this->assertNotNull(
            $subscription->starts_at
        );

        $this->assertNotNull(
            $subscription->expires_at
        );

        $this->assertEquals(
            '2026-09-23 14:00:00',
            $subscription->expires_at->format('Y-m-d H:i:s')
        );
    }

    /**
     * A user cannot have multiple active subscriptions.
     */
    public function test_user_cannot_have_multiple_active_subscriptions(): void
    {
        $user = User::factory()->create();

        $plan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium-multiple-test',
            'description' => 'Premium test plan',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $service = app(SubscriptionService::class);

        $service->activateSubscription($user, $plan);

        $this->expectException(RuntimeException::class);

        $service->activateSubscription($user, $plan);
    }

    /**
     * An active subscription can be expired.
     */
    public function test_active_subscription_can_be_expired(): void
    {
        $user = User::factory()->create();

        $plan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium-expire-test',
            'description' => 'Premium test plan',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $service = app(SubscriptionService::class);

        $subscription = $service->activateSubscription(
            $user,
            $plan
        );

        Carbon::setTestNow('2026-09-23 14:00:00');

        $service->expireSubscription($subscription);

        $subscription->refresh();

        $this->assertEquals(
            'expired',
            $subscription->status
        );

        $this->assertNotNull(
            $subscription->expires_at
        );
    }

    /**
     * An active subscription can be cancelled.
     */
    public function test_active_subscription_can_be_cancelled(): void
    {
        $user = User::factory()->create();

        $plan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium-cancel-test',
            'description' => 'Premium test plan',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $service = app(SubscriptionService::class);

        $subscription = $service->activateSubscription(
            $user,
            $plan
        );

        $service->cancelSubscription($subscription);

        $subscription->refresh();

        $this->assertEquals(
            'cancelled',
            $subscription->status
        );

        $this->assertNotNull(
            $subscription->cancelled_at
        );

        $this->assertFalse(
            $subscription->auto_renew
        );
    }

    /**
     * The service correctly detects an active subscription.
     */
    public function test_service_detects_active_subscription(): void
    {
        $user = User::factory()->create();

        $plan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium-active-test',
            'description' => 'Premium test plan',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $service = app(SubscriptionService::class);

        $this->assertFalse(
            $service->hasActiveSubscription($user)
        );

        $service->activateSubscription($user, $plan);

        $this->assertTrue(
            $service->hasActiveSubscription($user)
        );
    }

    /**
     * The service returns the user's current active subscription.
     */
    public function test_service_returns_current_subscription(): void
    {
        $user = User::factory()->create();

        $plan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium-current-test',
            'description' => 'Premium test plan',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $service = app(SubscriptionService::class);

        $this->assertNull(
            $service->currentSubscription($user)
        );

        $subscription = $service->activateSubscription(
            $user,
            $plan
        );

        $current = $service->currentSubscription($user);

        $this->assertNotNull($current);

        $this->assertEquals(
            $subscription->id,
            $current->id
        );
    }
}