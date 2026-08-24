<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('subscriptions', function (Blueprint $table) {

            if (!Schema::hasColumn('subscriptions', 'next_billing_at')) {
                $table->timestamp('next_billing_at')
                    ->nullable()
                    ->after('expires_at');
            }

            if (!Schema::hasColumn('subscriptions', 'payment_provider')) {
                $table->string('payment_provider')
                    ->nullable()
                    ->after('next_billing_at');
            }

            if (!Schema::hasColumn('subscriptions', 'payment_method_id')) {
                $table->string('payment_method_id')
                    ->nullable()
                    ->after('payment_provider');
            }

        });
    }

    public function down(): void
    {
        Schema::table('subscriptions', function (Blueprint $table) {

            $columns = [];

            if (Schema::hasColumn('subscriptions', 'next_billing_at')) {
                $columns[] = 'next_billing_at';
            }

            if (Schema::hasColumn('subscriptions', 'payment_provider')) {
                $columns[] = 'payment_provider';
            }

            if (Schema::hasColumn('subscriptions', 'payment_method_id')) {
                $columns[] = 'payment_method_id';
            }

            if (!empty($columns)) {
                $table->dropColumn($columns);
            }
        });
    }
};