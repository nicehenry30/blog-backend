<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('referrals', function (Blueprint $table) {
            $table->id();

            $table->foreignId('referrer_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->foreignId('referred_user_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->string('referral_code');

            $table->decimal('reward_amount', 12, 2)
                ->default(0);

            $table->string('reward_currency')
                ->default('USD');

            $table->enum('status', [
                'pending',
                'qualified',
                'rewarded',
                'cancelled',
            ])->default('pending');

            $table->timestamp('qualified_at')
                ->nullable();

            $table->timestamp('rewarded_at')
                ->nullable();

            $table->timestamps();

            $table->unique([
                'referrer_id',
                'referred_user_id',
            ]);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('referrals');
    }
};