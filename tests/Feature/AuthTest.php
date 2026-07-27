<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_register(): void
    {
        $response = $this->postJson('/api/register', [
            'name' => 'Henry',
            'email' => 'henry@example.com',
            'password' => 'password123',
        ]);

        $response
            ->assertStatus(201)
            ->assertJsonStructure([
                'message',
                'user',
                'token',
            ]);

        $this->assertDatabaseHas('users', [
            'name' => 'Henry',
            'email' => 'henry@example.com',
        ]);
    }

    public function test_user_cannot_register_with_existing_email(): void
    {
        $this->postJson('/api/register', [
            'name' => 'Henry',
            'email' => 'henry@example.com',
            'password' => 'password123',
        ]);

        $response = $this->postJson('/api/register', [
            'name' => 'Another Henry',
            'email' => 'henry@example.com',
            'password' => 'password456',
        ]);

        $response
            ->assertStatus(422)
            ->assertJsonValidationErrors([
                'email',
            ]);
    }
}