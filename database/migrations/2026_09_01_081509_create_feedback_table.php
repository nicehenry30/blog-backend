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
        Schema::create('feedback', function (Blueprint $table) {
            $table->id();

            /*
             * User who submitted the feedback.
             */
            $table->foreignId('user_id')
                ->constrained()
                ->cascadeOnDelete();

            /*
             * Feedback category.
             *
             * Examples:
             * general
             * bug
             * signal
             * education
             * guardian
             * payment
             * other
             */
            $table->string('category');

            /*
             * Short description of the feedback.
             */
            $table->string('subject');

            /*
             * Full feedback message.
             */
            $table->text('message');

            /*
             * Response from the Tradewisser admin.
             */
            $table->text('admin_reply')->nullable();

            /*
             * Feedback workflow status.
             *
             * pending
             * in_review
             * resolved
             * closed
             */
            $table->string('status')->default('pending');

            /*
             * When an admin replied.
             */
            $table->timestamp('replied_at')->nullable();

            $table->timestamps();

            /*
             * Useful for retrieving a user's
             * feedback in chronological order.
             */
            $table->index(['user_id', 'created_at']);

            /*
             * Useful for admin filtering.
             */
            $table->index('status');
            $table->index('category');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('feedback');
    }
};