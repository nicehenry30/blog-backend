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
        Schema::create('signal_histories', function (Blueprint $table) {

            $table->id();

            $table->foreignId('signal_id')
                ->constrained()
                ->cascadeOnDelete();

            $table->foreignId('user_id')
                ->nullable()
                ->constrained()
                ->nullOnDelete();

            $table->string('event');

            $table->string('old_status')
                ->nullable();

            $table->string('new_status')
                ->nullable();

            $table->text('description');

            $table->json('metadata')
                ->nullable();

            $table->timestamps();

            $table->index('signal_id');
            $table->index('event');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('signal_histories');
    }
};