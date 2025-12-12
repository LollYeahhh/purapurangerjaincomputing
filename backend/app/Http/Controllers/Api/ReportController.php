<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Assignments;
use App\Models\Checksheet_Master;
use App\Models\ChecksheetData;
use Illuminate\Http\Request;

class ReportController extends Controller
{
    /**
     * POST /api/laporan/cek-atau-buat
     *
     * Dipanggil saat mekanik memilih jadwal di dashboard.
     */
    public function cekAtauBuat(Request $request)
    {
        // 1. Autentikasi – pastikan route pakai middleware auth:sanctum / jwt
        $mekanik = $request->user();

        // 2. Validasi input
        $validated = $request->validate([
            'jadwal_id'    => ['required', 'integer', 'exists:assignments,jadwal_id'],
            'stamformasi'  => ['required', 'array'],
            'stamformasi.*'=> ['string'],
        ]);
        // Kalau gagal → Laravel otomatis balikin 422 dengan format
        // { message: "...", errors: {...} } (sesuai dokumentasi 422)

        $jadwalId = $validated['jadwal_id'];

        // 3. Ambil jadwal (assignments)
        $jadwal = Assignments::findOrFail($jadwalId);

        // 4. Cek apakah sudah ada draft untuk KA / jadwal ini
        // Di DB kamu belum ada kolom jadwal_id di checksheet__masters,
        // jadi kita pakai penghubung via no_ka.
        $existingDraft = Checksheet_Master::where('no_ka', $jadwal->no_ka)
            ->where('status', 'Draft')
            ->first();

        // 5. Kalau sudah ada draft
        if ($existingDraft) {
            // cek apakah mekaniknya sama
            if ((int) $existingDraft->mekanik_id === (int) $mekanik->user_id
                || (property_exists($mekanik, 'user_id') && (int) $existingDraft->mekanik_id === (int) $mekanik->user_id)
            ) {
                // mekanik sama → lanjutkan draft
                return response()->json([
                    'status'  => 'success',
                    'message' => 'Laporan siap diisi.',
                    'data'    => [
                        'laporan_id'     => $existingDraft->master_id,
                        'status_laporan' => $existingDraft->status, // harusnya "Draft"
                    ],
                ], 200);
            }

            // mekanik beda → kunci, balikin error 401 (sesuai dokumen)
            return response()->json([
                'status'  => 'error',
                'message' => 'Laporan untuk KA ini sedang dikerjakan (status Draft) oleh mekanik lain.',
            ], 401);
        }

        // 6. Kalau belum ada draft → buat baru
        $now = now();

        $newDraft = Checksheet_Master::create([
            'no_ka'            => $jadwal->no_ka,
            'name_ka'          => $jadwal->nama_ka,
            'tanggal_inspeksi' => $now->toDateString(),
            'status'           => 'Draft',
            // sesuaikan PK user: id / user_id
            'mekanik_id'       => $mekanik->user_id,
            'pengawas_id'      => $mekanik->user_id, // placeholder
            'catatan_pengawas' => '',

            // karena di migration kamu timestamp-nya tidak nullable,
            // kita isi saja biar DB nggak error
            'created_at'       => $now,
            'submitted_at'     => $now,
            'approved_at'      => $now,
        ]);

        // NOTE: field 'stamformasi' dari request belum disimpan ke DB,
        // nanti bisa kamu pakai untuk tabel detail terpisah (Form Type 3).

        return response()->json([
            'status'  => 'success',
            'message' => 'Laporan siap diisi.',
            'data'    => [
                'laporan_id'     => $newDraft->master_id,
                'status_laporan' => $newDraft->status, // "Draft"
            ],
        ], 200);
    }
     public function simpanDataInventaris(Request $request, int $id)
    {
        $mekanik = $request->user();
        if (! $mekanik) {
            return response()->json([
                'message' => 'Unauthenticated.',
            ], 401);
        }

        $validated = $request->validate([
            'nama_sheet'      => ['required', 'string'],
            'data'            => ['required', 'array', 'min:1'],
            'data.*.item_pemeriksaan' => ['required', 'string'],
            'data.*.hasil_input'      => ['required', 'string'],
            'data.*.keterangan'       => ['nullable', 'string'],
        ]);

        $namaSheet = $validated['nama_sheet'];

        $laporan = Checksheet_Master::findOrFail($id);

        $mekanikId = $mekanik->user_id;

        $bolehEdit = ((int) $laporan->mekanik_id === (int) $mekanikId)
            && $laporan->status !== 'Approved';

        if (! $bolehEdit) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Anda tidak memiliki izin untuk mengubah laporan ini.',
            ], 403);
        }

        foreach ($validated['data'] as $row) {
            \App\Models\Checksheet_Data::updateOrCreate(
                [
                    'master_id'        => $laporan->master_id,
                    'nama_sheet'       => $namaSheet,
                    'item_pemeriksaan' => $row['item_pemeriksaan'],
                ],
                [
                    'hasil_input' => $row['hasil_input'],
                    'keterangan'  => $row['keterangan'] ?? null,
                ]
            );
        }

        return response()->json([
            'status'  => 'success',
            'message' => "Data '{$namaSheet}' telah berhasil disimpan.",
        ], 200);
    }   // <--- method simpanDataInventaris selesai
     /**
     * POST /api/laporan/{id}/simpan-data-komponen
     * Tipe 2 – Komponen / Mekanik / Genset
     */
    public function simpanDataKomponen(Request $request, int $id)
    {
        $mekanik = $request->user();
        if (! $mekanik) {
            return response()->json([
                'message' => 'Unauthenticated.',
            ], 401);
        }

        $validated = $request->validate([
            'nama_sheet'      => ['required', 'string'],
            'data'            => ['required', 'array', 'min:1'],
            'data.*.item_pemeriksaan' => ['required', 'string'],
            'data.*.standar'          => ['required', 'string'],
            'data.*.hasil_input'      => ['required', 'string'],
            'data.*.keterangan'       => ['nullable', 'string'],
        ]);

        $namaSheet = $validated['nama_sheet'];
        $laporan   = Checksheet_Master::findOrFail($id);
        $mekanikId = $mekanik->user_id;

        $bolehEdit = ((int) $laporan->mekanik_id === (int) $mekanikId)
            && $laporan->status !== 'Approved';

        if (! $bolehEdit) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Anda tidak memiliki izin untuk mengubah laporan ini.',
            ], 403);
        }

        foreach ($validated['data'] as $row) {
            \App\Models\Checksheet_Data::updateOrCreate(
                [
                    'master_id'        => $laporan->master_id,
                    'nama_sheet'       => $namaSheet,
                    'item_pemeriksaan' => $row['item_pemeriksaan'],
                ],
                [
                    'standar'     => $row['standar'],
                    'hasil_input' => $row['hasil_input'],
                    'keterangan'  => $row['keterangan'] ?? null,
                ]
            );
        }

        return response()->json([
            'status'  => 'success',
            'message' => "Data '{$namaSheet}' telah berhasil disimpan.",
        ], 200);
    }
        /**
     * POST /api/laporan/{id}/simpan-data-matriks
     * Tipe 3 – Matriks (Mekanik 2 / Electric)
     */
    public function simpanDataMatriks(Request $request, int $id)
    {
        $mekanik = $request->user();
        if (! $mekanik) {
            return response()->json([
                'message' => 'Unauthenticated.',
            ], 401);
        }

        // Validasi sesuai dokumentasi
        $validated = $request->validate([
            'nama_sheet'      => ['required', 'string'],
            'data'            => ['required', 'array', 'min:1'],

            'data.*.item_pemeriksaan' => ['required', 'string'],
            'data.*.nomor_gerbong'    => ['required', 'string'],
            'data.*.standar'          => ['required', 'string'],
            'data.*.hasil_input'      => ['required', 'string'],
            'data.*.keterangan'       => ['nullable', 'string'],
        ]);

        $namaSheet = $validated['nama_sheet'];

        // Ambil master laporan
        $laporan   = Checksheet_Master::findOrFail($id);
        $mekanikId = $mekanik->user_id;

        // Hanya pemilik & status bukan Approved yang boleh edit
        $bolehEdit = ((int) $laporan->mekanik_id === (int) $mekanikId)
            && $laporan->status !== 'Approved';

        if (! $bolehEdit) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Anda tidak memiliki izin untuk mengubah laporan ini.',
            ], 403);
        }

        // Simpan / update tiap sel matriks
        foreach ($validated['data'] as $row) {
           \App\Models\Checksheet_Data::updateOrCreate(
                [
                    'master_id'        => $laporan->master_id,
                    'nama_sheet'       => $namaSheet,
                    'item_pemeriksaan' => $row['item_pemeriksaan'],
                    'nomor_gerbong'    => $row['nomor_gerbong'],
                ],
                [
                    'standar'     => $row['standar'],
                    'hasil_input' => $row['hasil_input'],
                    'keterangan'  => $row['keterangan'] ?? null,
                ]
            );
        }

        return response()->json([
            'status'  => 'success',
            'message' => "Data '{$namaSheet}' telah berhasil disimpan.",
        ], 200);
    }
    /**
     * POST /api/laporan/{id}/ajukan-approval
     *
     * Mengubah status laporan dari Draft -> Pending (Pending Approval)
     * setelah memvalidasi kepemilikan & kelengkapan 6 sheet pra-keberangkatan.
     */
    public function ajukanApproval(Request $request, int $id)
    {
        $mekanik = $request->user();
        if (! $mekanik) {
            return response()->json([
                'message' => 'Unauthenticated.',
            ], 401);
        }

        // Ambil laporan
        $laporan = Checksheet_Master::findOrFail($id);
        $mekanikId = $mekanik->user_id;

        // Hanya pemilik yang boleh submit
        if ((int) $laporan->mekanik_id !== (int) $mekanikId) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Anda tidak memiliki izin untuk mengubah laporan ini.',
            ], 403);
        }

        // Kalau sudah Approved, jelas nggak boleh
        if ($laporan->status === 'Approved') {
            return response()->json([
                'status'  => 'error',
                'message' => 'Laporan ini sudah berstatus Approved dan tidak dapat diajukan kembali.',
            ], 403);
        }

        // 6 sheet pra-keberangkatan yang wajib ada
        $requiredSheets = [
            'Tool Box',
            'Tool Kit',
            'Mekanik',
            'Genset',
            'Mekanik 2',
            'Electric',
        ];

        $completed = [];
        $missing   = [];

        foreach ($requiredSheets as $sheet) {
            $exists =\App\Models\Checksheet_Data::where('master_id', $laporan->master_id)
                ->where('nama_sheet', $sheet)
                ->exists();

            if ($exists) {
                $completed[] = $sheet;
            } else {
                $missing[] = $sheet;
            }
        }

        // Jika masih ada sheet yang belum diisi → 422
        if (! empty($missing)) {
            return response()->json([
                'status' => [
                    'completed_sheets' => $completed,
                    'missing_sheets'   => $missing,
                ],
                'message' => 'Gagal mengajukan: Pastikan semua 6 form pra-keberangkatan sudah terisi lengkap.',
            ], 422);
        }

        // Semua sheet lengkap → ubah status ke Pending (Pending Approval)
        $laporan->status       = 'Pending';  // DB enum kamu: Draft / Pending / Approval / Approved / Rejected
        $laporan->submitted_at = now();
        $laporan->save();

        return response()->json([
            'status'  => 'success',
            'message' => 'Laporan telah berhasil diajukan ke Pengawas.',
            'data'    => [
                'laporan_id' => $laporan->master_id,
                'new_status' => $laporan->status, // "Pending"
            ],
        ], 200);
    }
       public function logGangguan(Request $request, int $id)
    {
        $mekanik = $request->user();
        if (! $mekanik) {
            return response()->json([
                'message' => 'Unauthenticated.',
            ], 401);
        }

        // Validasi input (422 kalau gagal)
        $validated = $request->validate([
            'identitas_komponen' => ['required', 'string'],
            'bentuk_gangguan'    => ['required', 'string'],
            'tindak_lanjut'      => ['required', 'string'],
        ]);

        // Ambil laporan induk
        $laporan   = Checksheet_Master::findOrFail($id);
        $mekanikId = $mekanik->user_id;

        // Hanya pemilik laporan yang boleh nambah log
        if ((int) $laporan->mekanik_id !== (int) $mekanikId) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Anda tidak memiliki izin untuk mengubah laporan ini.',
            ], 403);
        }

        // Insert baris baru ke tabel log_gangguans (atau sesuai model-mu)
        $now = now();

        /** @var \App\Models\Log_Gangguan $log */
        $log = \App\Models\Log_Gangguan::create([
            'master_id'          => $laporan->master_id,
            'identitas_komponen' => $validated['identitas_komponen'],
            'bentuk_gangguan'    => $validated['bentuk_gangguan'],
            'tindak_lanjut'      => $validated['tindak_lanjut'],
            'waktu_lapor'        => $now, // pastikan kolom ini ada di tabel1
        ]);

        return response()->json([
            'status'  => 'success',
            'message' => 'Log gangguan berhasil ditambahkan.',
            'data'    => [
                // sesuaikan dengan nama PK di tabelmu
                'gangguan_id'        => $log->gangguan_id ?? $log->id,
                'master_id'          => $log->master_id,
                'identitas_komponen' => $log->identitas_komponen,
                'bentuk_gangguan'    => $log->bentuk_gangguan,
                'tindak_lanjut'      => $log->tindak_lanjut,
                'waktu_lapor'        => $log->waktu_lapor,
            ],
        ], 201);
    }

}

