<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class AssignmentsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('assignments')->insert([
            'user_id' => 1,
            'no_ka' => 'KA ' . rand(10, 100),
            'nama_ka' => Str::random(),
            'jam_berangkat' => rand(0, 23) . ':' . rand(0, 59)
        ]);
    }
}