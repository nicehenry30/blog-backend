<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

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
}
