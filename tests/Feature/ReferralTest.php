<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;
use App\Models\Referral;

class ReferralTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_gets_referral_code_when_registered(): void
    {
        $response = $this->postJson('/api/register', [
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => 'password123',
        ]);

        $response->assertStatus(201);

        $user = User::where(
            'email',
            'john@example.com'
        )->first();

        $this->assertNotNull($user);
        $this->assertNotNull($user->referral_code);
        $this->assertNotEmpty($user->referral_code);
    }

    public function test_user_can_register_with_referral_code(): void
    {
        $referrer = User::create([
            'name' => 'Referrer',
            'email' => 'referrer@example.com',
            'password' => Hash::make('password123'),
            'referral_code' => 'REF12345',
        ]);

        $response = $this->postJson('/api/register', [
            'name' => 'Referred User',
            'email' => 'referred@example.com',
            'password' => 'password123',
            'referral_code' => 'REF12345',
        ]);

        $response->assertStatus(201);

        $referredUser = User::where(
            'email',
            'referred@example.com'
        )->first();

        $this->assertNotNull($referredUser);

        $this->assertEquals(
            $referrer->id,
            $referredUser->referred_by_user_id
        );

        $this->assertDatabaseHas('referrals', [
            'referrer_id' => $referrer->id,
            'referred_user_id' => $referredUser->id,
            'referral_code' => 'REF12345',
            'status' => 'pending',
        ]);
    }

    public function test_invalid_referral_code_is_rejected(): void
    {
        $response = $this->postJson('/api/register', [
            'name' => 'New User',
            'email' => 'new@example.com',
            'password' => 'password123',
            'referral_code' => 'INVALID123',
        ]);

        $response->assertStatus(422);

        $this->assertDatabaseMissing('users', [
            'email' => 'new@example.com',
        ]);
    }

    public function test_user_cannot_refer_themselves(): void
    {
        $user = User::create([
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => Hash::make('password123'),
            'referral_code' => 'JOHN1234',
        ]);

        $response = $this->postJson('/api/register', [
            'name' => 'Another Account',
            'email' => 'another@example.com',
            'password' => 'password123',
            'referral_code' => 'JOHN1234',
        ]);

        $response->assertStatus(201);

        $referredUser = User::where(
            'email',
            'another@example.com'
        )->first();

        $this->assertNotNull($referredUser);

        $this->assertNotEquals(
            $referredUser->id,
            $referredUser->referred_by_user_id
        );
    }

        public function test_authenticated_user_can_view_referral_summary(): void
    {
        $user = User::create([
            'name' => 'Referrer',
            'email' => 'referrer@example.com',
            'password' => Hash::make('password123'),
            'referral_code' => 'REF12345',
        ]);

        $response = $this
            ->actingAs($user, 'sanctum')
            ->getJson('/api/referral');

        $response
            ->assertStatus(200)
            ->assertJson([
                'referral_code' => 'REF12345',
                'total_referrals' => 0,
                'pending' => 0,
                'qualified' => 0,
                'rewarded' => 0,
                'total_rewards' => '0.00',
                'reward_currency' => 'USD',
            ]);
    }

    public function test_unauthenticated_user_cannot_view_referral_summary(): void
    {
        $response = $this->getJson('/api/referral');

        $response->assertStatus(401);
    }

    public function test_authenticated_user_can_view_their_referrals(): void
    {
        $referrer = User::create([
            'name' => 'Referrer',
            'email' => 'referrer@example.com',
            'password' => Hash::make('password123'),
            'referral_code' => 'REF12345',
        ]);

        $referredUser = User::create([
            'name' => 'Referred User',
            'email' => 'referred@example.com',
            'password' => Hash::make('password123'),
            'referral_code' => 'USER1234',
        ]);

        Referral::create([
            'referrer_id' => $referrer->id,
            'referred_user_id' => $referredUser->id,
            'referral_code' => 'REF12345',
            'reward_amount' => 5,
            'reward_currency' => 'USD',
            'status' => 'qualified',
            'qualified_at' => now(),
        ]);

        $response = $this
            ->actingAs($referrer, 'sanctum')
            ->getJson('/api/referrals');

        $response
            ->assertStatus(200)
            ->assertJsonCount(1, 'data')
            ->assertJsonPath(
                'data.0.status',
                'qualified'
            )
            ->assertJsonPath(
                'data.0.referral_code',
                'REF12345'
            )
            ->assertJsonPath(
                'data.0.referred_user.id',
                $referredUser->id
            )
            ->assertJsonPath(
                'data.0.referred_user.name',
                'Referred User'
            );
    }

    public function test_unauthenticated_user_cannot_view_referrals(): void
    {
        $response = $this->getJson('/api/referrals');

        $response->assertStatus(401);
    }

    public function test_user_only_sees_their_own_referrals(): void
    {
        $user = User::create([
            'name' => 'User One',
            'email' => 'user1@example.com',
            'password' => Hash::make('password123'),
            'referral_code' => 'USER1111',
        ]);

        $otherUser = User::create([
            'name' => 'User Two',
            'email' => 'user2@example.com',
            'password' => Hash::make('password123'),
            'referral_code' => 'USER2222',
        ]);

        $referredUser = User::create([
            'name' => 'Referred User',
            'email' => 'referred@example.com',
            'password' => Hash::make('password123'),
            'referral_code' => 'REF12345',
        ]);

        Referral::create([
            'referrer_id' => $otherUser->id,
            'referred_user_id' => $referredUser->id,
            'referral_code' => 'USER2222',
            'reward_amount' => 10,
            'reward_currency' => 'USD',
            'status' => 'rewarded',
            'rewarded_at' => now(),
        ]);

        $response = $this
            ->actingAs($user, 'sanctum')
            ->getJson('/api/referrals');

        $response
            ->assertStatus(200)
            ->assertJsonCount(0, 'data');
    }
}
