<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Carbon\Carbon;

class ChecksheetMastersSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $assignments = DB::table('assignments')->get();

        foreach ($assignments as $assignment) {
            DB::table('checksheet__masters')->insert([

                'no_ka'            => $assignment->no_ka,
                'name_ka'          => $assignment->nama_ka,
                'tanggal_inspeksi' => Carbon::now()->toDateString(),
                'status'           => collect(["Draft","Pending","Approval","Approved","Rejected"])->random(),
                'mekanik_id'       => 1,
                'pengawas_id'      => 1,
                'catatan_pengawas' => 'Catatan untuk ' . $assignment->no_ka,
                'created_at'       => Carbon::now(),
                'submitted_at'     => Carbon::now(),
                'approved_at'      => Carbon::now(),
            ]);
        }
    }
}