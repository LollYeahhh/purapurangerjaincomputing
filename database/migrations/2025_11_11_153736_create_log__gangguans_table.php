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
        Schema::create('log__gangguans', function (Blueprint $table) {
            $table->id('gangguan_id')->primary();
            $table->foreignId('master_id')->constrained('checksheet__masters', 'master_id')->cascadeOnDelete();
            $table->string('identitas_komponen');
            $table->text('bentuk_gangguan');
            $table->text('tindak_lanjut');
            $table->timestamp('waktu_lapor');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('log__gangguans');
    }
};
