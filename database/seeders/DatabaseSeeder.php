<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // generate beberapa user dummy
        User::factory()->create([
            'name'  => 'Test User',
            'email' => 'test@example.com',
        ]);

        // generate user tambahan
        User::factory(5)->create();

        // panggil seeder lain
        $this->call([
            AssignmentsSeeder::class,
            ChecksheetMastersSeeder::class,
        ]);
    }
}