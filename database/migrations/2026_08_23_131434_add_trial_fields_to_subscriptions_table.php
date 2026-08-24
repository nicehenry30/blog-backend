<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('subscriptions', function (Blueprint $table) {

            $table->boolean('is_trial')
                ->default(false)
                ->after('auto_renew');

            $table->timestamp('trial_ends_at')
                ->nullable()
                ->after('is_trial');

            $table->boolean('payment_method_verified')
                ->default(false)
                ->after('trial_ends_at');

            $table->string('payment_method_reference')
                ->nullable()
                ->after('payment_method_verified');

        });
    }

    public function down(): void
    {
        Schema::table('subscriptions', function (Blueprint $table) {

            $table->dropColumn([
                'is_trial',
                'trial_ends_at',
                'payment_method_verified',
                'payment_method_reference',
            ]);

        });
    }
};