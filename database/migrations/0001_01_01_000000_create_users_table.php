<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('roles', function (Blueprint $table) {
            $table->id('role_id');
            $table->string('role_name',50);
            $table->primary('role_id');
            $table->unique('role_name');
        });

        DB::table('roles')->insert(['role_name' => 'Admin']);
        DB::table('roles')->insert(['role_name' => 'Pengawas']);
        DB::table('roles')->insert(['role_name' => 'Mekanik']);

        Schema::create('users', function (Blueprint $table) {
            $table->id('user_id')->primary();
            $table->string('name',100);
            $table->string('nipp',50)->unique();
            $table->string('password_hash');
            $table->foreignId('role_id')->constrained('roles', 'role_id')->cascadeOnDelete();
            $table->boolean('is_active');

        });

        Schema::create('sessions', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->foreignId('user_id')->nullable()->index();
            $table->string('ip_address', 45)->nullable();
            $table->text('user_agent')->nullable();
            $table->longText('payload');
            $table->integer('last_activity')->index();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
        Schema::dropIfExists('roles');
        Schema::dropIfExists('password_reset_tokens');
        Schema::dropIfExists('sessions');
    }
};
