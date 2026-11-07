<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasColumn('subscriptions', 'payment_method_reference')) {
            Schema::table('subscriptions', function (Blueprint $table) {
                $table->string('payment_method_reference')->nullable();
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('subscriptions', 'payment_method_reference')) {
            Schema::table('subscriptions', function (Blueprint $table) {
                $table->dropColumn('payment_method_reference');
            });
        }
    }
};