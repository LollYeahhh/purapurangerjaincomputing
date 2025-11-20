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
        Schema::create('checksheet__masters', function (Blueprint $table) {
            $table->id('master_id')->primary();
            $table->string('no_ka',50);
            $table->string('name_ka',100);
            $table->date('tanggal_inspeksi');
            $table->enum('status',["Draft","Pending","Approval","Approved","Rejected"]);
            $table->foreignId('mekanik_id')->constrained('users', 'user_id')->cascadeOnDelete();
            $table->foreignId('pengawas_id')->constrained('users', 'user_id')->cascadeOnDelete();
            $table->text('catatan_pengawas');
            $table->timestamp('created_at');
            $table->timestamp('submitted_at');
            $table->timestamp('approved_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('checksheet__masters');
    }
};
