<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('news_evidence', function (Blueprint $table) {
            $table->id();

            $table->foreignId('news_id')
                ->constrained('news')
                ->cascadeOnDelete();

            $table->string('symbol');
            $table->decimal('sentiment_score', 8, 5)->nullable();
            $table->decimal('match_score', 12, 5)->nullable();
            $table->json('highlights')->nullable();

            $table->timestamps();

            $table->index('symbol');
            $table->index('sentiment_score');

            $table->unique([
                'news_id',
                'symbol',
            ]);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('news_evidence');
    }
};