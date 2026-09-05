<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Add fields required for manual USDT payments.
     */
    public function up(): void
    {
        Schema::table('payments', function (Blueprint $table) {

            $table->string('crypto_network', 20)
                ->nullable()
                ->after('gateway_currency');

            $table->string('crypto_address', 255)
                ->nullable()
                ->after('crypto_network');

            $table->string('transaction_hash', 255)
                ->nullable()
                ->unique()
                ->after('crypto_address');

            $table->timestamp('submitted_at')
                ->nullable()
                ->after('transaction_hash');

            $table->timestamp('reviewed_at')
                ->nullable()
                ->after('submitted_at');

            $table->foreignId('reviewed_by')
                ->nullable()
                ->after('reviewed_at')
                ->constrained('users')
                ->nullOnDelete();

        });
    }

    /**
     * Remove manual crypto payment fields.
     */
    public function down(): void
    {
        Schema::table('payments', function (Blueprint $table) {

            $table->dropForeign([
                'reviewed_by',
            ]);

            $table->dropUnique([
                'payments_transaction_hash_unique',
            ]);

            $table->dropColumn([
                'crypto_network',
                'crypto_address',
                'transaction_hash',
                'submitted_at',
                'reviewed_at',
                'reviewed_by',
            ]);

        });
    }
};