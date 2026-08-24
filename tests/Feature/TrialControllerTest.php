<?php

namespace Tests\Feature;

use App\Models\Plan;
use App\Models\Subscription;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TrialControllerTest extends TestCase
{
    use RefreshDatabase;

    private function createPlan(): Plan
    {
        return Plan::create([
            'name' => 'Premium',
            'slug' => 'premium',
            'description' => 'Premium trading plan',
            'price' => 29.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);
    }

    public function test_authenticated_user_can_start_trial(): void
    {
        $user = User::factory()->create();

        $plan = $this->createPlan();

        $response = $this->actingAs($user)
            ->postJson('/api/subscription/trial', [
                'plan_id' => $plan->id,
                'payment_provider' => 'test',
                'payment_method_id' => 'payment_method_123',
            ]);

        $response->assertStatus(201)
            ->assertJson([
                'message' => 'Free trial started successfully.',
            ]);

        $this->assertDatabaseHas('subscriptions', [
            'user_id' => $user->id,
            'plan_id' => $plan->id,
            'status' => 'active',
            'is_trial' => true,
            'payment_provider' => 'test',
            'payment_method_id' => 'payment_method_123',
            'payment_method_verified' => true,
        ]);
    }

    public function test_unauthenticated_user_cannot_start_trial(): void
    {
        $plan = $this->createPlan();

        $response = $this->postJson('/api/subscription/trial', [
            'plan_id' => $plan->id,
            'payment_provider' => 'test',
            'payment_method_id' => 'payment_method_123',
        ]);

        $response->assertUnauthorized();
    }

    public function test_user_can_view_current_trial(): void
    {
        $user = User::factory()->create();

        $plan = $this->createPlan();

        Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $plan->id,
            'status' => 'active',
            'starts_at' => now(),
            'expires_at' => now()->addDays(7),
            'cancelled_at' => null,
            'auto_renew' => true,
            'is_trial' => true,
            'trial_started_at' => now(),
            'trial_ends_at' => now()->addDays(7),
            'next_billing_at' => now()->addDays(7),
            'payment_provider' => 'test',
            'payment_method_id' => 'payment_method_123',
            'payment_method_verified' => true,
        ]);

        $response = $this->actingAs($user)
            ->getJson('/api/subscription/trial');

        $response->assertOk()
            ->assertJsonPath('trial.is_trial', true)
            ->assertJsonPath('trial.status', 'active')
            ->assertJsonPath('trial.payment_provider', 'test');
    }

    public function test_user_without_active_trial_gets_404(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)
            ->getJson('/api/subscription/trial');

        $response->assertStatus(404)
            ->assertJson([
                'message' => 'No active trial found.',
            ]);
    }

    public function test_user_cannot_start_trial_twice(): void
    {
        $user = User::factory()->create();

        $plan = $this->createPlan();

        $this->actingAs($user)
            ->postJson('/api/subscription/trial', [
                'plan_id' => $plan->id,
                'payment_provider' => 'test',
                'payment_method_id' => 'payment_method_123',
            ])
            ->assertStatus(201);

        $response = $this->actingAs($user)
            ->postJson('/api/subscription/trial', [
                'plan_id' => $plan->id,
                'payment_provider' => 'test',
                'payment_method_id' => 'payment_method_456',
            ]);

        $response->assertStatus(422)
            ->assertJson([
                'message' => 'This user has already used their free trial.',
            ]);
    }

    public function test_user_with_active_subscription_cannot_start_trial(): void
    {
        $user = User::factory()->create();

        $plan = $this->createPlan();

        Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $plan->id,
            'status' => 'active',
            'starts_at' => now(),
            'expires_at' => now()->addMonth(),
            'auto_renew' => true,
            'is_trial' => false,
        ]);

        $response = $this->actingAs($user)
            ->postJson('/api/subscription/trial', [
                'plan_id' => $plan->id,
                'payment_provider' => 'test',
                'payment_method_id' => 'payment_method_123',
            ]);

        $response->assertStatus(422)
            ->assertJson([
                'message' => 'The user already has an active subscription.',
            ]);
    }

    public function test_trial_validation_rejects_missing_payment_information(): void
    {
        $user = User::factory()->create();

        $plan = $this->createPlan();

        $response = $this->actingAs($user)
            ->postJson('/api/subscription/trial', [
                'plan_id' => $plan->id,
            ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors([
                'payment_provider',
                'payment_method_id',
            ]);
    }
}