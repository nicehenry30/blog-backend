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
        Schema::table('user_settings', function (Blueprint $table) {

            $table->decimal('minimum_signal_quality', 5, 2)
                ->default(70.00)
                ->after('auto_trading_enabled');

            $table->decimal('minimum_ai_confidence', 5, 2)
                ->default(70.00)
                ->after('minimum_signal_quality');

            $table->boolean('allow_buy')
                ->default(true)
                ->after('minimum_ai_confidence');

            $table->boolean('allow_sell')
                ->default(true)
                ->after('allow_buy');

            $table->boolean('require_ai_confirmation')
                ->default(true)
                ->after('allow_sell');

            $table->boolean('require_stop_loss')
                ->default(true)
                ->after('require_ai_confirmation');

            $table->boolean('require_take_profit')
                ->default(true)
                ->after('require_stop_loss');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('user_settings', function (Blueprint $table) {
            $table->dropColumn([
                'minimum_signal_quality',
                'minimum_ai_confidence',
                'allow_buy',
                'allow_sell',
                'require_ai_confirmation',
                'require_stop_loss',
                'require_take_profit',
            ]);
        });
    }
};