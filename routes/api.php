<?php

use App\Http\Controllers\Api\AuthController;
use Illuminate\Support\Facades\Route;

Route::post('/login', [AuthController::class, 'APILogin']);

Route::middleware('auth:sanctum')->group(function() {
    Route::post('/auth/change-password', [AuthController::class, 'APIChangePassword']);
    Route::post('/logout', [AuthController::class, 'APILogout']);
});