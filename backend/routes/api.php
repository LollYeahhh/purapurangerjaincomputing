<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DashboardController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ReportController;
use App\Http\Controllers\Api\DashboardPengawasController;
use App\Http\Controllers\Api\ReportPengawasController;

Route::post('/login', [AuthController::class, 'APILogin']);

Route::middleware('auth:sanctum')->group(function() {
    Route::get('/dashboard/jadwal', [DashboardController::class, 'jadwal']);
    Route::post('/auth/change-password', [AuthController::class, 'APIChangePassword']);
    Route::post('/logout', [AuthController::class, 'APILogout']);
    Route::post('/laporan/cek-atau-buat', [ReportController::class, 'cekAtauBuat']);
    Route::post('/laporan/{id}/simpan-data-inventaris', [ReportController::class, 'simpanDataInventaris']);
    Route::post('/laporan/{id}/simpan-data-komponen',   [ReportController::class, 'simpanDataKomponen']);
    Route::post('/laporan/{id}/simpan-data-matriks',    [ReportController::class, 'simpanDataMatriks']);
    Route::post('/laporan/{id}/ajukan-approval',        [ReportController::class, 'ajukanApproval']);
    Route::post('/laporan/{id}/log-gangguan',           [ReportController::class, 'logGangguan']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/dashboard/pengawas', [DashboardPengawasController::class, 'DashboardPengawas']);
    Route::get('/laporan/{id}', [ReportPengawasController::class, 'show']);
    Route::post('/laporan/{id}/approve', [ReportPengawasController::class, 'approve']);
    Route::post('/laporan/{id}/reject', [ReportPengawasController::class, 'reject']);
    Route::get('/laporan/{id}/download-pdf', [ReportPengawasController::class, 'downloadPdf']);
});
});