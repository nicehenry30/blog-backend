<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('signals', function (Blueprint $table) {

            $table->id();

            /*
            |--------------------------------------------------------------------------
            | Symbol
            |--------------------------------------------------------------------------
            */

            $table->foreignId('symbol_id')
                ->constrained()
                ->cascadeOnDelete();

            /*
            |--------------------------------------------------------------------------
            | Trade Setup
            |--------------------------------------------------------------------------
            */

            $table->enum('direction', [
                'BUY',
                'SELL',
            ]);

            $table->decimal('entry_price', 12, 5);

            $table->decimal('stop_loss', 12, 5);

            $table->decimal('take_profit', 12, 5);

            $table->decimal('take_profit_2', 12, 5)
                ->nullable();

            $table->decimal('take_profit_3', 12, 5)
                ->nullable();

            /*
            |--------------------------------------------------------------------------
            | Trade Information
            |--------------------------------------------------------------------------
            */

            $table->string('timeframe');

            $table->decimal('signal_quality', 5, 2);

            $table->decimal('overall_confidence', 5, 2);

            $table->string('strategy')
                ->nullable();

            $table->decimal('risk_reward', 5, 2)
                ->nullable();

            $table->longText('analysis')
                ->nullable();

            /*
            |--------------------------------------------------------------------------
            | AI
            |--------------------------------------------------------------------------
            */

            $table->unsignedTinyInteger('ai_score')
                ->nullable();

            $table->text('ai_comment')
                ->nullable();

            /*
            |--------------------------------------------------------------------------
            | Extras
            |--------------------------------------------------------------------------
            */

            $table->json('confluences')
                ->nullable();

            $table->string('chart_image')
                ->nullable();

            /*
            |--------------------------------------------------------------------------
            | Workflow
            |--------------------------------------------------------------------------
            */

            $table->enum('status', [
                'Draft',
                'Pending',
                'Approved',
                'Published',
                'Running',
                'TP1 Hit',
                'TP2 Hit',
                'TP3 Hit',
                'Closed',
                'Rejected',
                'Cancelled',
                'Expired',
            ])->default('Draft');

            /*
            |--------------------------------------------------------------------------
            | Dates
            |--------------------------------------------------------------------------
            */

            $table->timestamp('approved_at')
                ->nullable();

            $table->timestamp('published_at')
                ->nullable();

            $table->timestamp('closed_at')
                ->nullable();

            /*
            |--------------------------------------------------------------------------
            | Results
            |--------------------------------------------------------------------------
            */

            $table->enum('result', [
                'win',
                'loss',
                'breakeven',
            ])->nullable();

            $table->integer('pips')
                ->nullable();

            /*
            |--------------------------------------------------------------------------
            | Users
            |--------------------------------------------------------------------------
            */

            $table->foreignId('created_by')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->foreignId('approved_by')
                ->nullable()
                ->constrained('users')
                ->nullOnDelete();

            $table->timestamps();

            /*
            |--------------------------------------------------------------------------
            | Indexes
            |--------------------------------------------------------------------------
            */

            $table->index('status');
            $table->index('published_at');
            $table->index('created_by');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('signals');
    }
};