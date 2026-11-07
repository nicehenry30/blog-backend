<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('news', function (Blueprint $table) {
            $table->id();

            $table->string('title');
            $table->text('description')->nullable();

            $table->text('url');
            $table->string('source')->nullable();

            $table->timestamp('published_at')->nullable();

            $table->text('image_url')->nullable();

            $table->json('symbols')->nullable();
            $table->json('currencies')->nullable();
            $table->json('entities')->nullable();

            $table->string('sentiment')->nullable();
            $table->decimal('sentiment_score', 8, 5)->nullable();

            $table->json('raw_data')->nullable();

            $table->timestamps();

            
            $table->index('published_at');
            $table->index('source');
            $table->index('sentiment');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('news');
    }
};