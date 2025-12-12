<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Checksheet_Master;
use App\Models\Checksheet_Data;
use App\Models\Log_Gangguan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use App\Models\Laporan_PDF;
use PDF;


class ReportPengawasController extends Controller
{
    /**
     * GET /api/laporan/{id}
     * Pengawas melihat detail laporan lengkap.
     */
    public function show(Request $request, int $id)
    {
        $user = $request->user();

        // 1. Autentikasi wajib
        if (! $user) {
            return response()->json([
                'message' => 'Unauthenticated.'
            ], 401);
        }

        // 2. Cek role Pengawas
        if ($user->role !== 'Pengawas') {
            return response()->json([
                'status'  => 'error',
                'message' => 'Anda tidak memiliki izin untuk mengakses sumber daya ini.',
            ], 403);
        }

        // 3. Ambil laporan (atau 404)
        $laporan = Checksheet_Master::with('mekanik')  // relasi untuk nama mekanik
            ->find($id);

        if (! $laporan) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Laporan tidak ditemukan.',
            ], 404);
        }

        // 4. Ambil semua sheet
        $allSheets = Checksheet_Data::where('master_id', $laporan->master_id)->get();

        // Filter berdasarkan sheet name
        $sheets = [
            'tool_box'   => $allSheets->where('nama_sheet', 'Tool Box')->values(),
            'tool_kit'   => $allSheets->where('nama_sheet', 'Tool Kit')->values(),
            'mekanik'    => $allSheets->where('nama_sheet', 'Mekanik')->values(),
            'genset'     => $allSheets->where('nama_sheet', 'Genset')->values(),
            'mekanik_2'  => $allSheets->where('nama_sheet', 'Mekanik 2')->values(),
            'electric'   => $allSheets->where('nama_sheet', 'Electric')->values(),
        ];

        // 5. Ambil log gangguan
        $logGangguan = Log_Gangguan::where('master_id', $laporan->master_id)->get();

        // 6. Susun response sesuai dokumentasi
        return response()->json([
            'status' => 'success',
            'data'   => [
                'master_info' => [
                    'laporan_id'        => $laporan->master_id,
                    'no_ka'             => $laporan->no_ka,
                    'nama_ka'           => $laporan->name_ka,
                    'status'            => $laporan->status,
                    'nama_mekanik'      => optional($laporan->mekanik)->nama ?? '-',
                    'submitted_at'      => $laporan->submitted_at,
                    'catatan_pengawas'  => $laporan->catatan_pengawas,
                ],

                'sheets' => [
                    'tool_box'   => $sheets['tool_box'],
                    'tool_kit'   => $sheets['tool_kit'],
                    'mekanik'    => $sheets['mekanik'],
                    'genset'     => $sheets['genset'],
                    'mekanik_2'  => $sheets['mekanik_2'],
                    'electric'   => $sheets['electric'],
                    'log_gangguan' => $logGangguan,
                ],
            ]
        ], 200);
    }
    public function approve(Request $request, int $id)
{
    $user = $request->user();

    if (! $user) {
        return response()->json(['message' => 'Unauthenticated.'], 401);
    }

    if ($user->role !== 'Pengawas') {
        return response()->json([
            'status'  => 'error',
            'message' => 'Anda tidak memiliki izin untuk mengakses sumber daya ini.',
        ], 403);
    }

    $laporan = Checksheet_Master::find($id);

    if (! $laporan) {
        return response()->json([
            'status'  => 'error',
            'message' => 'Laporan tidak ditemukan.'
        ], 404);
    }

    // ❗ Hanya boleh approve jika status Pending
    if ($laporan->status !== 'Pending') {
        return response()->json([
            'status' => 'error',
            'message' => "Gagal: Laporan ini tidak dalam status 'Pending Approval'."
        ], 422);
    }

    // Set pengawas + approved_at + status
    $laporan->status = 'Approved';
    $laporan->pengawas_id = $user->user_id;
    $laporan->approved_at = now();
    $laporan->save();

    // 🔥 Generate PDF (contoh sederhana)
    $pdfName = 'laporan-'.$laporan->master_id.'.pdf';
    $path = 'laporan_pdfs/' . $pdfName;

    $pdf = Laporan_PDF::loadView('pdf.laporan', ['laporan' => $laporan]);
    Storage::disk('public')->put($path, $pdf->output());

    // Simpan PDF ke tabel laporan_pdfs (opsional jika ada tabelnya)
    // LaporanPdf::create([...]);

    return response()->json([
        'status' => 'success',
        'message' => 'Laporan telah berhasil disetujui. PDF sedang dibuat.',
        'data' => [
            'laporan_id' => $laporan->master_id,
            'new_status' => $laporan->status,
            'pdf_url'    => Storage::url($path)
        ]
    ], 200);
}
    public function reject(Request $request, int $id)
{
    $user = $request->user();

    if (! $user) {
        return response()->json(['message' => 'Unauthenticated.'], 401);
    }

    if ($user->role !== 'Pengawas') {
        return response()->json([
            'status' => 'error',
            'message' => 'Anda tidak memiliki izin untuk mengakses sumber daya ini.'
        ], 403);
    }

    $laporan = Checksheet_Master::find($id);

    if (! $laporan) {
        return response()->json([
            'status' => 'error',
            'message' => 'Laporan tidak ditemukan.'
        ], 404);
    }

    // ❗ Validasi status harus "Pending"
    if ($laporan->status !== 'Pending') {
        return response()->json([
            'status' => 'error',
            'message' => "Gagal: Laporan ini tidak dalam status 'Pending Approval'."
        ], 422);
    }

    // Validasi request
    $validated = $request->validate([
        'catatan_pengawas' => ['required', 'string']
    ]);

    // Proses Reject
    $laporan->status = 'Rejected';
    $laporan->pengawas_id = $user->user_id;
    $laporan->catatan_pengawas = $validated['catatan_pengawas'];
    $laporan->save();

    return response()->json([
        'status' => 'success',
        'message' => 'Laporan telah ditolak dan dikembalikan ke Mekanik.',
        'data' => [
            'laporan_id' => $laporan->master_id,
            'new_status' => $laporan->status
        ]
    ], 200);
}
    public function downloadPdf(Request $request, int $id)
{
    $user = $request->user();

    if (! $user) {
        return response()->json(['message' => 'Unauthenticated.'], 401);
    }

    if (! in_array($user->role, ['Pengawas', 'Admin'])) {
        return response()->json([
            'status' => 'error',
            'message' => 'Anda tidak memiliki izin untuk mengakses sumber daya ini.'
        ], 403);
    }

    $laporan = Checksheet_Master::find($id);

    if (! $laporan) {
        return response()->json([
            'status' => 'error',
            'message' => 'Laporan tidak ditemukan.'
        ], 404);
    }

    // ❗ PDF hanya ada jika laporan Approved
    if ($laporan->status !== 'Approved') {
        return response()->json([
            'status' => 'error',
            'message' => 'PDF belum tersedia. Laporan harus disetujui (Approved).'
        ], 403);
    }

    // Path PDF
    $pdfName = 'laporan-'.$laporan->master_id.'.pdf';
    $path = 'laporan_pdfs/' . $pdfName;

    if (! Storage::disk('public')->exists($path)) {
        return response()->json([
            'status' => 'error',
            'message' => 'Laporan atau file PDF tidak ditemukan.'
        ], 404);
    }

    return response()->json([
        'status' => 'success',
        'data'   => [
            'download_url' => Storage::url($path)
        ]
    ], 200);
}

}