<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('payments', function (Blueprint $table) {

            $table->id();

            $table->foreignId('subscription_id')
                ->constrained()
                ->cascadeOnDelete();

            $table->foreignId('user_id')
                ->constrained()
                ->cascadeOnDelete();

            $table->decimal('amount', 10, 2);

            $table->string('currency', 10)
                ->default('USD');

            $table->string('gateway');

            $table->string('reference')
                ->unique();

            $table->string('transaction_id')
                ->nullable();

            $table->enum('status', [
                'pending',
                'successful',
                'failed',
                'cancelled',
                'refunded',
            ])->default('pending');

            $table->json('gateway_response')
                ->nullable();

            $table->timestamp('paid_at')
                ->nullable();

            $table->timestamps();

            $table->index([
                'user_id',
                'status',
            ]);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('payments');
    }
};