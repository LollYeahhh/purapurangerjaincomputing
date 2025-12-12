<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Checksheet_Master;
use App\Models\User;

class DashboardPengawasController extends Controller
{
    /**
     * GET /api/dashboard/pengawas
     *
     * Mengembalikan:
     * - daftar laporan Pending Approval
     * - daftar laporan Approved (30 hari terakhir)
     */
    public function index(Request $request)
    {
        $user = $request->user();

        // Hanya Pengawas yang boleh akses endpoint ini
        if ($user->role->role_name !== 'Pengawas') {
            return response()->json([
                'status'  => 'error',
                'message' => 'Anda tidak memiliki izin untuk mengakses sumber daya ini.',
            ], 403);
        }

        // =========================================================
        // 1) PENDING APPROVAL (status = "Pending")
        // =========================================================
        $pending = Checksheet_Master::where('status', 'Pending')
            ->orderBy('submitted_at', 'desc')
            ->get()
            ->map(function ($row) {
                return [
                    'laporan_id'   => $row->master_id,
                    'no_ka'        => $row->no_ka,
                    'nama_ka'      => $row->name_ka,
                    'nama_mekanik' => optional($row->mekanik)->name ?? '-',
                    'submitted_at' => $row->submitted_at,
                ];
            });

        // =========================================================
        // 2) APPROVED (30 hari terakhir)
        // =========================================================
        $approved = Checksheet_Master::where('status', 'Approved')
            ->where('approved_at', '>=', now()->subDays(30))
            ->orderBy('approved_at', 'desc')
            ->get()
            ->map(function ($row) {
                return [
                    'laporan_id'   => $row->master_id,
                    'no_ka'        => $row->no_ka,
                    'nama_ka'      => $row->name_ka,
                    'nama_mekanik' => optional($row->mekanik)->name ?? '-',
                    'approved_at'  => $row->approved_at,
                    'pdf_url'      => $row->pdf_url ?? null, // jika tabel kamu ada pdf_url
                ];
            });

        // =========================================================
        // RESPONSE FORMAT SESUAI DOKUMENTASI
        // =========================================================
        return response()->json([
            'status' => 'success',
            'data'   => [
                'pending_approval' => $pending,
                'riwayat_approved' => $approved,
            ],
        ], 200);
    }
}