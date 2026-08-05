<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('guardian_accounts', function (Blueprint $table) {
            $table->string('device_token_hash', 64)
                ->nullable()
                ->unique()
                ->after('broker');
        });
    }

    public function down(): void
    {
        Schema::table('guardian_accounts', function (Blueprint $table) {
            $table->dropUnique([
                'device_token_hash',
            ]);

            $table->dropColumn(
                'device_token_hash'
            );
        });
    }
};