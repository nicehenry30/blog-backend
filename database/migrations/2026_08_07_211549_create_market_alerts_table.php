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
        Schema::create('market_alerts', function (Blueprint $table) {
            $table->id();

            $table->string('title');

            $table->string('currency', 10);

            $table->enum('impact', [
                'low',
                'medium',
                'high',
            ]);

            $table->dateTime('alert_time');

            $table->text('recommendation');

            $table->boolean('is_active')
                ->default(true);

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('market_alerts');
    }
};