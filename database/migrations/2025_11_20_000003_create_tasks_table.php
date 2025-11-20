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
        if (! Schema::hasTable('tasks')) {
            Schema::create('tasks', function (Blueprint $table) {
                $table->id();

                $table->foreignId('user_id')->constrained()->cascadeOnDelete();
                $table->foreignId('category_id')->nullable()->constrained()->nullOnDelete();

                $table->string('title');
                $table->text('description')->nullable();

                $table->enum('status', ['todo', 'in_progress', 'done'])->default('todo');
                $table->enum('priority', ['low', 'medium', 'high', 'urgent'])->default('medium');

                $table->date('due_date')->nullable();
                $table->boolean('is_completed')->default(false);
                $table->timestamp('completed_at')->nullable();

                $table->softDeletes();
                $table->timestamps();

                $table->index(['user_id']);
                $table->index(['category_id']);
                $table->index(['status']);
                $table->index(['priority']);
                $table->index(['due_date']);
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tasks');
    }
};
