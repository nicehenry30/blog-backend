<?php

namespace Tests\Feature;

use App\Models\Payment;
use App\Models\Plan;
use App\Models\Subscription;
use App\Models\User;
use App\Services\PaystackService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PaystackPaymentFlowTest extends TestCase
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

    private function mockPaystackInitialization(
        string $reference = 'TW-TEST-REFERENCE',
        string $authorizationUrl = 'https://checkout.paystack.com/test',
        string $accessCode = 'test-access-code'
    ): void {
        $this->mock(PaystackService::class, function ($mock) use (
            $reference,
            $authorizationUrl,
            $accessCode
        ) {
            $mock->shouldReceive('initialize')
                ->once()
                ->andReturn([
                    'status' => true,
                    'message' => 'Authorization URL created',
                    'data' => [
                        'authorization_url' => $authorizationUrl,
                        'access_code' => $accessCode,
                        'reference' => $reference,
                    ],
                ]);
        });
    }

    public function test_authenticated_user_can_initialize_paystack_payment(): void
    {
        $user = User::factory()->create();
        $plan = $this->createPlan();

        $this->mockPaystackInitialization(
            'TW-TEST-REFERENCE',
            'https://checkout.paystack.com/test',
            'test-access-code'
        );

        $response = $this
            ->actingAs($user, 'sanctum')
            ->postJson('/api/payments/initialize', [
                'plan_id' => $plan->id,
            ]);

        $response->assertStatus(200)
            ->assertJsonStructure([
                'payment',
                'subscription',
                'authorization_url',
                'access_code',
                'reference',
            ]);

        $this->assertDatabaseHas('subscriptions', [
            'user_id' => $user->id,
            'plan_id' => $plan->id,
            'status' => 'pending',
        ]);

        $this->assertDatabaseHas('payments', [
            'user_id' => $user->id,
            'gateway' => 'paystack',
            'status' => 'pending',
        ]);
    }

    public function test_unauthenticated_user_cannot_initialize_payment(): void
    {
        $plan = $this->createPlan();

        $response = $this->postJson('/api/payments/initialize', [
            'plan_id' => $plan->id,
        ]);

        $response->assertStatus(401);
    }

    public function test_successful_paystack_payment_activates_pending_subscription(): void
    {
        $user = User::factory()->create();
        $plan = $this->createPlan();

        $subscription = Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $plan->id,
            'status' => 'pending',
            'starts_at' => null,
            'expires_at' => null,
            'next_billing_at' => null,
            'auto_renew' => true,
            'is_trial' => false,
        ]);

        $payment = Payment::create([
            'user_id' => $user->id,
            'subscription_id' => $subscription->id,
            'amount' => 29.99,
            'currency' => 'USD',
            'gateway' => 'paystack',
            'reference' => 'TW-VERIFY-001',
            'status' => 'pending',
        ]);

        $this->mock(PaystackService::class, function ($mock) use ($payment) {
            $mock->shouldReceive('verifyTransaction')
                ->once()
                ->with($payment->reference)
                ->andReturn([
                    'status' => true,
                    'message' => 'Verification successful',
                    'data' => [
                        'status' => 'success',
                        'reference' => $payment->reference,
                        'id' => 123456789,
                    ],
                ]);
        });

        $response = $this
            ->actingAs($user, 'sanctum')
            ->postJson('/api/payments/verify', [
                'reference' => $payment->reference,
            ]);

        $response->assertStatus(200)
            ->assertJson([
                'message' => 'Payment verified successfully.',
            ]);

        $this->assertDatabaseHas('subscriptions', [
            'id' => $subscription->id,
            'status' => 'active',
        ]);

        $this->assertDatabaseHas('payments', [
            'id' => $payment->id,
            'status' => 'successful',
        ]);
    }

    public function test_successful_payment_cannot_create_another_subscription(): void
    {
        $user = User::factory()->create();
        $plan = $this->createPlan();

        Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $plan->id,
            'status' => 'active',
            'starts_at' => now()->subDays(5),
            'expires_at' => now()->addDays(25),
            'next_billing_at' => now()->addDays(25),
            'auto_renew' => true,
            'is_trial' => false,
        ]);

        $response = $this
            ->actingAs($user, 'sanctum')
            ->postJson('/api/payments/initialize', [
                'plan_id' => $plan->id,
            ]);

        $response->assertStatus(400);
    }

    public function test_invalid_paystack_verification_fails_payment(): void
    {
        $user = User::factory()->create();
        $plan = $this->createPlan();

        $subscription = Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $plan->id,
            'status' => 'pending',
            'starts_at' => null,
            'expires_at' => null,
            'next_billing_at' => null,
            'auto_renew' => true,
            'is_trial' => false,
        ]);

        $payment = Payment::create([
            'user_id' => $user->id,
            'subscription_id' => $subscription->id,
            'amount' => 29.99,
            'currency' => 'USD',
            'gateway' => 'paystack',
            'reference' => 'TW-INVALID-001',
            'status' => 'pending',
        ]);

        $this->mock(PaystackService::class, function ($mock) use ($payment) {
            $mock->shouldReceive('verifyTransaction')
                ->once()
                ->with($payment->reference)
                ->andReturn([
                    'status' => false,
                    'message' => 'Verification failed',
                ]);
        });

        $response = $this
            ->actingAs($user, 'sanctum')
            ->postJson('/api/payments/verify', [
                'reference' => $payment->reference,
            ]);

        $response->assertStatus(400)
            ->assertJson([
                'message' => 'Payment verification failed.',
            ]);

        $this->assertDatabaseHas('payments', [
            'id' => $payment->id,
            'status' => 'failed',
        ]);

        $this->assertDatabaseHas('subscriptions', [
            'id' => $subscription->id,
            'status' => 'pending',
        ]);
    }

    public function test_active_subscription_can_be_upgraded_to_a_higher_plan(): void
    {
        $user = User::factory()->create();

        $currentPlan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium-current',
            'description' => 'Current Premium plan',
            'price' => 19.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $upgradePlan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium-upgrade',
            'description' => 'Higher Premium plan',
            'price' => 49.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 2,
        ]);

        $currentSubscription = Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $currentPlan->id,
            'status' => 'active',
            'starts_at' => now()->subDays(5),
            'expires_at' => now()->addDays(25),
            'next_billing_at' => now()->addDays(25),
            'auto_renew' => true,
            'is_trial' => false,
        ]);

        $this->mockPaystackInitialization(
            'TW-UPGRADE-REFERENCE',
            'https://checkout.paystack.com/test-upgrade',
            'upgrade-access-code'
        );

        $response = $this
            ->actingAs($user, 'sanctum')
            ->postJson('/api/payments/initialize', [
                'plan_id' => $upgradePlan->id,
            ]);

        $response->assertStatus(200)
            ->assertJsonStructure([
                'payment',
                'subscription',
                'authorization_url',
                'access_code',
                'reference',
            ]);

        $newSubscription = Subscription::where('user_id', $user->id)
            ->where('plan_id', $upgradePlan->id)
            ->latest('id')
            ->first();

        $this->assertNotNull($newSubscription);

        $this->assertEquals(
            'pending',
            $newSubscription->status
        );

        $this->assertDatabaseHas('subscriptions', [
            'id' => $currentSubscription->id,
            'status' => 'active',
        ]);

        $this->assertDatabaseHas('subscriptions', [
            'id' => $newSubscription->id,
            'plan_id' => $upgradePlan->id,
            'status' => 'pending',
        ]);
    }

    public function test_user_cannot_upgrade_to_same_plan(): void
    {
        $user = User::factory()->create();

        $plan = $this->createPlan();

        Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $plan->id,
            'status' => 'active',
            'starts_at' => now()->subDays(5),
            'expires_at' => now()->addDays(25),
            'next_billing_at' => now()->addDays(25),
            'auto_renew' => true,
            'is_trial' => false,
        ]);

        $response = $this
            ->actingAs($user, 'sanctum')
            ->postJson('/api/payments/initialize', [
                'plan_id' => $plan->id,
            ]);

        $response->assertStatus(400)
            ->assertJson([
                'message' =>
                    'You can only upgrade to a higher-priced plan.',
            ]);
    }

    public function test_user_cannot_downgrade_to_lower_plan(): void
    {
        $user = User::factory()->create();

        $currentPlan = Plan::create([
            'name' => 'Premium Pro',
            'slug' => 'premium-pro',
            'description' => 'Premium Pro',
            'price' => 49.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 2,
        ]);

        $lowerPlan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium',
            'description' => 'Premium',
            'price' => 19.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $currentPlan->id,
            'status' => 'active',
            'starts_at' => now(),
            'expires_at' => now()->addMonth(),
            'next_billing_at' => now()->addMonth(),
            'auto_renew' => true,
            'is_trial' => false,
        ]);

        $response = $this
            ->actingAs($user, 'sanctum')
            ->postJson('/api/payments/initialize', [
                'plan_id' => $lowerPlan->id,
            ]);

        $response->assertStatus(400)
            ->assertJson([
                'message' =>
                    'You can only upgrade to a higher-priced plan.',
            ]);
    }

    public function test_successful_upgrade_activates_new_subscription_and_keeps_old_subscription_from_being_active(): void
    {
        $user = User::factory()->create();

        $currentPlan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium-current',
            'description' => 'Current Premium plan',
            'price' => 19.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $upgradePlan = Plan::create([
            'name' => 'Premium Pro',
            'slug' => 'premium-pro',
            'description' => 'Premium Pro',
            'price' => 49.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 2,
        ]);

        $oldSubscription = Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $currentPlan->id,
            'status' => 'active',
            'starts_at' => now()->subDays(10),
            'expires_at' => now()->addDays(20),
            'next_billing_at' => now()->addDays(20),
            'auto_renew' => true,
            'is_trial' => false,
        ]);

        $newSubscription = Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $upgradePlan->id,
            'status' => 'pending',
            'starts_at' => null,
            'expires_at' => null,
            'next_billing_at' => null,
            'auto_renew' => true,
            'is_trial' => false,
            'payment_provider' => 'paystack',
        ]);

        $payment = Payment::create([
            'user_id' => $user->id,
            'subscription_id' => $newSubscription->id,
            'amount' => 49.99,
            'currency' => 'USD',
            'gateway' => 'paystack',
            'reference' => 'TW-UPGRADE-VERIFY-001',
            'status' => 'pending',
        ]);

        $this->mock(PaystackService::class, function ($mock) use ($payment) {
            $mock->shouldReceive('verifyTransaction')
                ->once()
                ->with($payment->reference)
                ->andReturn([
                    'status' => true,
                    'message' => 'Verification successful',
                    'data' => [
                        'status' => 'success',
                        'reference' => $payment->reference,
                        'id' => 123456789,
                    ],
                ]);
        });

        $response = $this
            ->actingAs($user, 'sanctum')
            ->postJson('/api/payments/verify', [
                'reference' => $payment->reference,
            ]);

        $response->assertStatus(200)
            ->assertJson([
                'message' => 'Payment verified successfully.',
            ]);

        $this->assertDatabaseHas('subscriptions', [
            'id' => $oldSubscription->id,
            'status' => 'cancelled',
        ]);

        $this->assertDatabaseHas('subscriptions', [
            'id' => $newSubscription->id,
            'plan_id' => $upgradePlan->id,
            'status' => 'active',
        ]);

        $this->assertDatabaseHas('payments', [
            'id' => $payment->id,
            'status' => 'successful',
        ]);
    }

    public function test_user_can_initialize_upgrade_to_higher_plan(): void
    {
        $user = User::factory()->create();

        $currentPlan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium-current',
            'description' => 'Premium',
            'price' => 19.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $upgradePlan = Plan::create([
            'name' => 'Premium Pro',
            'slug' => 'premium-pro',
            'description' => 'Premium Pro',
            'price' => 49.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 2,
        ]);

        Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $currentPlan->id,
            'status' => 'active',
            'starts_at' => now()->subDays(10),
            'expires_at' => now()->addDays(20),
            'next_billing_at' => now()->addDays(20),
            'auto_renew' => true,
            'is_trial' => false,
        ]);

        $this->mockPaystackInitialization(
            'TW-UPGRADE-001',
            'https://checkout.paystack.com/test-upgrade',
            'upgrade-access-code'
        );

        $response = $this
            ->actingAs($user, 'sanctum')
            ->postJson('/api/payments/initialize', [
                'plan_id' => $upgradePlan->id,
            ]);

        $response->assertStatus(200)
            ->assertJson([
                'is_upgrade' => true,
            ])
            ->assertJsonStructure([
                'payment',
                'subscription',
                'authorization_url',
                'access_code',
                'reference',
                'is_upgrade',
            ]);
    }

    public function test_successful_upgrade_activates_new_plan_and_retires_old_subscription(): void
    {
        $user = User::factory()->create();

        $currentPlan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium-current',
            'description' => 'Premium',
            'price' => 19.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $upgradePlan = Plan::create([
            'name' => 'Premium Pro',
            'slug' => 'premium-pro',
            'description' => 'Premium Pro',
            'price' => 49.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 2,
        ]);

        $oldSubscription = Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $currentPlan->id,
            'status' => 'active',
            'starts_at' => now()->subDays(10),
            'expires_at' => now()->addDays(20),
            'next_billing_at' => now()->addDays(20),
            'auto_renew' => true,
            'is_trial' => false,
        ]);

        $newSubscription = Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $upgradePlan->id,
            'status' => 'pending',
            'starts_at' => null,
            'expires_at' => null,
            'next_billing_at' => null,
            'auto_renew' => true,
            'is_trial' => false,
            'payment_provider' => 'paystack',
        ]);

        $payment = Payment::create([
            'user_id' => $user->id,
            'subscription_id' => $newSubscription->id,
            'amount' => 49.99,
            'currency' => 'USD',
            'gateway' => 'paystack',
            'reference' => 'TW-UPGRADE-VERIFY-002',
            'status' => 'pending',
        ]);

        $this->mock(PaystackService::class, function ($mock) use ($payment) {
            $mock->shouldReceive('verifyTransaction')
                ->once()
                ->with($payment->reference)
                ->andReturn([
                    'status' => true,
                    'message' => 'Verification successful',
                    'data' => [
                        'status' => 'success',
                        'reference' => $payment->reference,
                        'id' => 987654321,
                    ],
                ]);
        });

        $response = $this
            ->actingAs($user, 'sanctum')
            ->postJson('/api/payments/verify', [
                'reference' => $payment->reference,
            ]);

        $response->assertStatus(200);

        $this->assertDatabaseHas('subscriptions', [
            'id' => $oldSubscription->id,
            'status' => 'cancelled',
        ]);

        $this->assertDatabaseHas('subscriptions', [
            'id' => $newSubscription->id,
            'status' => 'active',
            'plan_id' => $upgradePlan->id,
        ]);
    }

    public function test_user_cannot_initialize_same_or_lower_plan(): void
    {
        $user = User::factory()->create();

        $currentPlan = Plan::create([
            'name' => 'Premium Pro',
            'slug' => 'premium-pro',
            'description' => 'Premium Pro',
            'price' => 49.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 2,
        ]);

        $lowerPlan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium',
            'description' => 'Premium',
            'price' => 19.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $currentPlan->id,
            'status' => 'active',
            'starts_at' => now(),
            'expires_at' => now()->addMonth(),
            'next_billing_at' => now()->addMonth(),
            'auto_renew' => true,
            'is_trial' => false,
        ]);

        $response = $this
            ->actingAs($user, 'sanctum')
            ->postJson('/api/payments/initialize', [
                'plan_id' => $lowerPlan->id,
            ]);

        $response->assertStatus(400)
            ->assertJson([
                'message' =>
                    'You can only upgrade to a higher-priced plan.',
            ]);
    }

    public function test_active_user_can_initialize_upgrade_to_higher_plan(): void
    {
        $user = User::factory()->create();

        $currentPlan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium',
            'description' => 'Premium trading plan',
            'price' => 19.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $upgradePlan = Plan::create([
            'name' => 'Premium Pro',
            'slug' => 'premium-pro',
            'description' => 'Premium Pro trading plan',
            'price' => 49.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 2,
        ]);

        Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $currentPlan->id,
            'status' => 'active',
            'starts_at' => now()->subDays(10),
            'expires_at' => now()->addDays(20),
            'next_billing_at' => now()->addDays(20),
            'auto_renew' => true,
            'is_trial' => false,
        ]);

        $this->mockPaystackInitialization(
            'TW-UPGRADE-001',
            'https://checkout.paystack.com/test-upgrade',
            'upgrade-access-code'
        );

        $response = $this
            ->actingAs($user, 'sanctum')
            ->postJson('/api/payments/initialize', [
                'plan_id' => $upgradePlan->id,
            ]);

        $response->assertStatus(200)
            ->assertJson([
                'is_upgrade' => true,
            ])
            ->assertJsonStructure([
                'payment',
                'subscription',
                'authorization_url',
                'access_code',
                'reference',
                'is_upgrade',
            ]);
    }

    public function test_successful_upgrade_activates_new_plan_and_cancels_old_plan(): void
    {
        $user = User::factory()->create();

        $currentPlan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium-current',
            'description' => 'Premium',
            'price' => 19.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $upgradePlan = Plan::create([
            'name' => 'Premium Pro',
            'slug' => 'premium-pro',
            'description' => 'Premium Pro',
            'price' => 49.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 2,
        ]);

        $oldSubscription = Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $currentPlan->id,
            'status' => 'active',
            'starts_at' => now()->subDays(10),
            'expires_at' => now()->addDays(20),
            'next_billing_at' => now()->addDays(20),
            'auto_renew' => true,
            'is_trial' => false,
        ]);

        $newSubscription = Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $upgradePlan->id,
            'status' => 'pending',
            'starts_at' => null,
            'expires_at' => null,
            'next_billing_at' => null,
            'auto_renew' => true,
            'is_trial' => false,
            'payment_provider' => 'paystack',
        ]);

        $payment = Payment::create([
            'user_id' => $user->id,
            'subscription_id' => $newSubscription->id,
            'amount' => 49.99,
            'currency' => 'USD',
            'gateway' => 'paystack',
            'reference' => 'TW-UPGRADE-CANCEL-001',
            'status' => 'pending',
        ]);

        $this->mock(PaystackService::class, function ($mock) use ($payment) {
            $mock->shouldReceive('verifyTransaction')
                ->once()
                ->with($payment->reference)
                ->andReturn([
                    'status' => true,
                    'message' => 'Verification successful',
                    'data' => [
                        'status' => 'success',
                        'reference' => $payment->reference,
                        'id' => 111222333,
                    ],
                ]);
        });

        $response = $this
            ->actingAs($user, 'sanctum')
            ->postJson('/api/payments/verify', [
                'reference' => $payment->reference,
            ]);

        $response->assertStatus(200);

        $this->assertDatabaseHas('subscriptions', [
            'id' => $oldSubscription->id,
            'status' => 'cancelled',
        ]);

        $this->assertDatabaseHas('subscriptions', [
            'id' => $newSubscription->id,
            'status' => 'active',
        ]);
    }

    public function test_active_user_cannot_downgrade_to_lower_plan(): void
    {
        $user = User::factory()->create();

        $currentPlan = Plan::create([
            'name' => 'Premium Pro',
            'slug' => 'premium-pro',
            'description' => 'Premium Pro',
            'price' => 49.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 2,
        ]);

        $lowerPlan = Plan::create([
            'name' => 'Premium',
            'slug' => 'premium',
            'description' => 'Premium',
            'price' => 19.99,
            'currency' => 'USD',
            'billing_cycle' => 'monthly',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        Subscription::create([
            'user_id' => $user->id,
            'plan_id' => $currentPlan->id,
            'status' => 'active',
            'starts_at' => now(),
            'expires_at' => now()->addMonth(),
            'next_billing_at' => now()->addMonth(),
            'auto_renew' => true,
            'is_trial' => false,
        ]);

        $response = $this
            ->actingAs($user, 'sanctum')
            ->postJson('/api/payments/initialize', [
                'plan_id' => $lowerPlan->id,
            ]);

        $response->assertStatus(400)
            ->assertJson([
                'message' =>
                    'You can only upgrade to a higher-priced plan.',
            ]);
    }
}