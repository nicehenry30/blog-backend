<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('guardian_accounts', function (Blueprint $table) {
            $table->id();

            $table->foreignId('user_id')
                ->constrained()
                ->cascadeOnDelete();

            $table->string('platform', 10)
                ->default('MT4');

            $table->string('account_number')
                ->nullable();

            $table->string('broker')
                ->nullable();

            $table->boolean('is_connected')
                ->default(false);

            $table->boolean('is_enabled')
                ->default(false);

            $table->decimal('balance', 15, 2)
                ->default(0);

            $table->decimal('equity', 15, 2)
                ->default(0);

            $table->decimal('current_drawdown', 8, 2)
                ->default(0);

            $table->unsignedInteger('open_positions')
                ->default(0);

            $table->decimal('daily_profit_loss', 15, 2)
                ->default(0);

            $table->timestamp('last_seen_at')
                ->nullable();

            $table->timestamps();

            $table->unique([
                'user_id',
                'platform',
                'account_number',
            ]);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('guardian_accounts');
    }
};