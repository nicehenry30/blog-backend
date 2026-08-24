<?php

namespace Tests\Feature;

use App\Models\Plan;
use App\Models\Subscription;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class SubscriptionControllerTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Authenticated user can view their current subscription.
     */
    public function test_authenticated_user_can_view_current_subscription(): void
    {
        $user = User::factory()->create();

        $plan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium',
            'description' => 'Premium trading plan',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $subscription = Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $plan->id,
            'status' => 'active',
            'starts_at' => now(),
            'expires_at' => now()->addMonth(),
            'next_billing_at' => now()->addMonth(),
            'auto_renew' => true,
            'is_trial' => false,
        ]);

        $response = $this
            ->actingAs($user)
            ->getJson('/api/subscription');

        $response
            ->assertStatus(200)
            ->assertJsonPath(
                'subscription.id',
                $subscription->id
            )
            ->assertJsonPath(
                'subscription.status',
                'active'
            )
            ->assertJsonPath(
                'subscription.plan.id',
                $plan->id
            );
    }

    /**
     * Unauthenticated user cannot view subscription.
     */
    public function test_unauthenticated_user_cannot_view_current_subscription(): void
    {
        $response = $this->getJson('/api/subscription');

        $response->assertStatus(401);
    }

    /**
     * User with no subscription receives 404.
     */
    public function test_user_without_subscription_gets_404(): void
    {
        $user = User::factory()->create();

        $response = $this
            ->actingAs($user)
            ->getJson('/api/subscription');

        $response
            ->assertStatus(404)
            ->assertJson([
                'message' => 'No active subscription found.',
            ]);
    }

    /**
     * Authenticated user can subscribe to an active plan.
     */
    public function test_user_can_subscribe_to_active_plan(): void
    {
        $user = User::factory()->create();

        $plan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium',
            'description' => 'Premium trading plan',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $response = $this
            ->actingAs($user)
            ->postJson('/api/subscription', [
                'plan_id' => $plan->id,
            ]);

        $response
            ->assertStatus(201)
            ->assertJsonPath(
                'subscription.plan_id',
                $plan->id
            )
            ->assertJsonPath(
                'subscription.status',
                'active'
            );

        $this->assertDatabaseHas('subscriptions', [
            'user_id' => $user->id,
            'plan_id' => $plan->id,
            'status' => 'active',
            'is_trial' => false,
            'auto_renew' => true,
        ]);
    }

    /**
     * User cannot subscribe twice while active.
     */
    public function test_user_cannot_have_multiple_active_subscriptions(): void
    {
        $user = User::factory()->create();

        $plan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium',
            'description' => 'Premium trading plan',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $this
            ->actingAs($user)
            ->postJson('/api/subscription', [
                'plan_id' => $plan->id,
            ])
            ->assertStatus(201);

        $response = $this
            ->actingAs($user)
            ->postJson('/api/subscription', [
                'plan_id' => $plan->id,
            ]);

        $response
            ->assertStatus(422)
            ->assertJson([
                'message' => 'The user already has an active subscription.',
            ]);
    }

    /**
     * User cannot subscribe to an inactive plan.
     */
    public function test_user_cannot_subscribe_to_inactive_plan(): void
    {
        $user = User::factory()->create();

        $plan = Plan::create([
            'name' => 'Inactive Plan',
            'slug' => 'inactive-plan',
            'description' => 'Inactive plan',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => false,
            'sort_order' => 1,
        ]);

        $response = $this
            ->actingAs($user)
            ->postJson('/api/subscription', [
                'plan_id' => $plan->id,
            ]);

        $response
            ->assertStatus(422)
            ->assertJson([
                'message' => 'This subscription plan is not active.',
            ]);

        $this->assertDatabaseMissing('subscriptions', [
            'user_id' => $user->id,
            'plan_id' => $plan->id,
        ]);
    }

    /**
     * Invalid plan ID is rejected.
     */
    public function test_invalid_plan_id_is_rejected(): void
    {
        $user = User::factory()->create();

        $response = $this
            ->actingAs($user)
            ->postJson('/api/subscription', [
                'plan_id' => 999999,
            ]);

        $response
            ->assertStatus(422)
            ->assertJsonValidationErrors([
                'plan_id',
            ]);
    }
}