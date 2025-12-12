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
        Schema::create('laporan__p_d_f_s', function (Blueprint $table) {
            $table->id('pdf_id')->primary();
            $table->foreignId('master_id')->constrained('checksheet__masters', 'master_id')->cascadeOnDelete();
            $table->string('file_url');
            $table->timestamp('generated_at');
            $table->date('expiry_date');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('laporan__p_d_f_s');
    }
};
