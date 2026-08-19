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
        Schema::table('signals', function (Blueprint $table) {

            $table->timestamp('tp1_hit_at')
                ->nullable()
                ->after('closed_at');

            $table->timestamp('tp2_hit_at')
                ->nullable()
                ->after('tp1_hit_at');

            $table->timestamp('tp3_hit_at')
                ->nullable()
                ->after('tp2_hit_at');

        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('signals', function (Blueprint $table) {

            $table->dropColumn([
                'tp1_hit_at',
                'tp2_hit_at',
                'tp3_hit_at',
            ]);

        });
    }
};