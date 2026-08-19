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
        Schema::create('guardian_trade_executions', function (Blueprint $table) {

            $table->id();

            // Guardian account that executed/rejected the trade
            $table->foreignId('guardian_account_id')
                ->constrained('guardian_accounts')
                ->cascadeOnDelete();

            // Tradewisser signal
            $table->foreignId('signal_id')
                ->nullable()
                ->constrained('signals')
                ->nullOnDelete();

            // MT4/MT5 ticket
            $table->string('ticket')
                ->nullable();

            $table->string('platform')
                ->default('MT4');

            $table->string('symbol');

            $table->string('direction');

            $table->decimal('lots', 10, 2)
                ->nullable();

            $table->decimal('entry_price', 20, 8)
                ->nullable();

            $table->decimal('stop_loss', 20, 8)
                ->nullable();

            $table->decimal('take_profit', 20, 8)
                ->nullable();

            // executed / rejected / failed
            $table->string('status');

            // Human-readable explanation
            $table->text('reason')
                ->nullable();

            // MT4/MT5 error code
            $table->integer('error_code')
                ->nullable();

            $table->timestamp('executed_at')
                ->nullable();

            $table->timestamps();

            // Prevent accidental duplicate reporting
            $table->index([
                'guardian_account_id',
                'signal_id',
            ]);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('guardian_trade_executions');
    }
};