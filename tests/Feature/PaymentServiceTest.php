<?php

namespace Tests\Feature;

use App\Models\Plan;
use App\Models\Subscription;
use App\Models\User;
use App\Services\PaymentService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use RuntimeException;
use Tests\TestCase;

class PaymentServiceTest extends TestCase
{
    use RefreshDatabase;

    public function test_payment_can_be_created(): void
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
            'auto_renew' => true,
        ]);

        $payment = app(PaymentService::class)->createPayment(
            $user,
            $subscription,
            29.99,
            'USD',
            'paystack',
            'PAY-TEST-001',
            29990.00,
            'NGN'
        );

        $this->assertDatabaseHas('payments', [
            'id' => $payment->id,
            'user_id' => $user->id,
            'subscription_id' => $subscription->id,
            'amount' => '29.99',
            'currency' => 'USD',
            'gateway' => 'paystack',
            'reference' => 'PAY-TEST-001',
            'status' => 'pending',
        ]);
    }

    public function test_payment_can_be_marked_successful(): void
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
            'auto_renew' => true,
        ]);

        $payment = app(PaymentService::class)->createPayment(
            $user,
            $subscription,
            29.99,
            'USD',
            'paystack',
            'PAY-TEST-002',
            29990.00,
            'NGN'
        );

        $payment = app(PaymentService::class)->markSuccessful(
            $payment,
            'TXN-TEST-002'
        );

        $this->assertEquals('successful', $payment->status);
        $this->assertEquals('TXN-TEST-002', $payment->transaction_id);
        $this->assertNotNull($payment->paid_at);

        $this->assertDatabaseHas('payments', [
            'id' => $payment->id,
            'status' => 'successful',
            'transaction_id' => 'TXN-TEST-002',
        ]);
    }

    public function test_payment_can_be_marked_failed(): void
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
            'auto_renew' => true,
        ]);

        $payment = app(PaymentService::class)->createPayment(
            $user,
            $subscription,
            29.99,
            'USD',
            'paystack',
            'PAY-TEST-003',
            29990.00,
            'NGN'
        );

        $payment = app(PaymentService::class)->markFailed(
            $payment
        );

        $this->assertEquals('failed', $payment->status);

        $this->assertDatabaseHas('payments', [
            'id' => $payment->id,
            'status' => 'failed',
        ]);
    }

    public function test_payment_reference_must_be_unique(): void
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
            'auto_renew' => true,
        ]);

        $service = app(PaymentService::class);

        $service->createPayment(
            $user,
            $subscription,
            29.99,
            'USD',
            'paystack',
            'PAY-DUPLICATE',
            29990.00,
            'NGN'
        );

        $this->expectException(\Illuminate\Database\QueryException::class);

        $service->createPayment(
            $user,
            $subscription,
            29.99,
            'USD',
            'paystack',
            'PAY-DUPLICATE',
            29990.00,
            'NGN'
        );
    }

    public function test_successful_payment_cannot_be_marked_failed(): void
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
            'auto_renew' => true,
        ]);

        $service = app(PaymentService::class);

        $payment = $service->createPayment(
            $user,
            $subscription,
            29.99,
            'USD',
            'paystack',
            'PAY-TEST-005',
            29990.00,
            'NGN'
        );

        $service->markSuccessful(
            $payment,
            'TXN-TEST-005'
        );

        $this->expectException(RuntimeException::class);

        $service->markFailed($payment);
    }

    public function test_payment_status_can_be_checked(): void
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
            'auto_renew' => true,
        ]);

        $service = app(PaymentService::class);

        $payment = $service->createPayment(
            $user,
            $subscription,
            29.99,
            'USD',
            'paystack',
            'PAY-TEST-006',
            29990.00,
            'NGN'
        );

        $this->assertTrue(
            $service->isPending($payment)
        );

        $service->markSuccessful(
            $payment,
            'TXN-TEST-006'
        );

        $this->assertFalse(
            $service->isPending($payment)
        );
    }
}