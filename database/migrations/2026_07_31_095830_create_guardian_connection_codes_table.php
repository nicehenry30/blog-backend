<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('guardian_connection_codes', function (Blueprint $table) {
            $table->id();

            $table->foreignId('user_id')
                ->constrained()
                ->cascadeOnDelete();

            $table->string('code', 20)
                ->unique();

            $table->string('platform', 10);

            $table->boolean('is_used')
                ->default(false);

            $table->timestamp('expires_at');

            $table->timestamp('used_at')
                ->nullable();

            $table->timestamps();

            $table->index([
                'user_id',
                'platform',
            ]);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('guardian_connection_codes');
    }
};