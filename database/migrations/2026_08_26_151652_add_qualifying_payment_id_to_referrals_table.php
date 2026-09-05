<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('referrals', function (Blueprint $table) {
            $table->foreignId('qualifying_payment_id')
                ->nullable()
                ->after('referred_user_id')
                ->constrained('payments')
                ->nullOnDelete();

            $table->unique('qualifying_payment_id');
        });
    }

    public function down(): void
    {
        Schema::table('referrals', function (Blueprint $table) {
            $table->dropUnique([
                'qualifying_payment_id',
            ]);

            $table->dropForeign([
                'qualifying_payment_id',
            ]);

            $table->dropColumn([
                'qualifying_payment_id',
            ]);
        });
    }
};