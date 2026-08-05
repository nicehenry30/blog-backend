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
        Schema::create('symbols', function (Blueprint $table) {

            $table->id();

            // Trading Symbol
            $table->string('symbol')->unique();

            // Full Name
            $table->string('name');

            // Asset Category
            $table->enum('asset_type', [
                'Forex',
                'Metal',
                'Crypto',
                'Index',
                'Commodity',
                'Stock',
                'ETF',
                'Other',
            ]);

            // Broker-specific symbol (optional)
            $table->string('broker_symbol')->nullable();

            // Decimal precision
            $table->unsignedTinyInteger('digits')
                ->default(5);

            // Active / Inactive
            $table->boolean('active')
                ->default(true);

            $table->timestamps();

            // Indexes
            $table->index('asset_type');
            $table->index('active');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('symbols');
    }
};