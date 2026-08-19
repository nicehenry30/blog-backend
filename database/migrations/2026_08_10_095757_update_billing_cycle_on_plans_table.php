<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        /*
        |--------------------------------------------------------------------------
        | SQLite does not support MODIFY COLUMN.
        |--------------------------------------------------------------------------
        */

        if (DB::getDriverName() === 'sqlite') {
            return;
        }

        DB::statement("
            ALTER TABLE plans
            MODIFY billing_cycle ENUM(
                'monthly',
                'three_months',
                'yearly',
                'two_year'
            ) NOT NULL
        ");
    }

    public function down(): void
    {
        /*
        |--------------------------------------------------------------------------
        | SQLite does not support MODIFY COLUMN.
        |--------------------------------------------------------------------------
        */

        if (DB::getDriverName() === 'sqlite') {
            return;
        }

        DB::statement("
            ALTER TABLE plans
            MODIFY billing_cycle ENUM(
                'monthly',
                'yearly',
                'lifetime'
            ) NOT NULL
        ");
    }
};