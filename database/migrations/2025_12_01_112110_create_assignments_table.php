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
        Schema::create('assignments', function (Blueprint $table) {
            // PK: jadwal_id (INT)
            $table->increments('jadwal_id'); // INT UNSIGNED AUTO_INCREMENT PRIMARY KEY

            // FK: user_id (BIGINT) -> users.id
            $table->foreignId('user_id')
                  ->constrained('users', 'user_id')
                  ->cascadeOnDelete();

            // Kolom lainnya sesuai ga
            $table->string('no_ka', 50);
            $table->string('nama_ka', 100);
            $table->time('jam_berangkat');

            // Jika kamu ingin pakai timestamps, tinggal uncomment:
            // $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('assignments');
    }
};