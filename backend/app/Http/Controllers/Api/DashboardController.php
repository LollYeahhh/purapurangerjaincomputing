<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Assignments;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function jadwal(Request $request)
    {
        // pake nama relasi persis: checksheet
        $assignments = Assignments::with('checksheet')
            ->orderBy('jam_berangkat', 'asc')
            ->get();

        if ($assignments->count() === 0) {
            return response()->json([
                'status' => 'success',
                'data'   => []
            ], 200);
        }

        $assignments = Assignments::with('checksheet')
    ->orderBy('jam_berangkat', 'asc')
    ->get();

        $data = $assignments->map(function ($item) {
    $checksheet = $item->checksheet;

    return [
        'jadwal_id'      => $item->jadwal_id,
        'no_ka'          => $item->no_ka,
        'nama_ka'        => $item->nama_ka,
        'jam_berangkat'  => $item->jam_berangkat,
        'status_laporan' => $checksheet ? $checksheet->status    : null,
        'laporan_id'     => $checksheet ? $checksheet->master_id : null,
    ];
});


        return response()->json([
            'status' => 'success',
            'data'   => $data
        ], 200);
    }
}