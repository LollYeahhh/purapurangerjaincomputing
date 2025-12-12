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
        Schema::create('checksheet__data', function (Blueprint $table) {
            $table->id('data_id')->primary();
            $table->foreignId('master_id')->constrained('checksheet__masters', 'master_id')->cascadeOnDelete();
            $table->string('nama_sheet', 50);
            $table->string('nomor_gerbong',50);
            $table->string('item_pemeriksaan');
            $table->string('standar', 100);
            $table->string('hasil_input');
            $table->text('keterangan');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('checksheet__data');
    }
};
