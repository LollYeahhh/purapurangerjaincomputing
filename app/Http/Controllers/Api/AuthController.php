<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\PersonalAccessToken;

class AuthController extends Controller
{
    public function APIlogin(Request $request){
        $userData = $request->validate([
            'nipp' => 'required|string',
            'password' => 'required',
            'device_name' => 'required|string'
        ]);
        $user = User::where('nipp', $userData['nipp'])->first();
        if(!$user || !Hash::check($userData['password'], $user->password_hash)){
            return response()->json([
                'status' => 'error',
                'message' => 'NIPP atau Password yang anda masukan salah.'
            ],401);
        }
        $token = $user->createToken($userData['device_name'] ?? 'auth_token')->plainTextToken;
        return response()->json([
            'status' => 'succes',
            'message' => 'Login berhasil',
            'token' => $token,
            'user' => $user,
            'user.nama_lengkap' => $user->name,
            'user.role' => $user->role->role_name,
            'is_first_login' => ($userData['nipp'] === $userData['password'])
        ]);
    }

    public function APILogout (Request $request){
        $accessToken = $request->bearerToken();
        $token = PersonalAccessToken::findToken($accessToken);
        $token->delete();
        return response()->json([
            'status' => 'success',
            'message' => 'Anda telah berhasil sukses.'
        ]);
    }
        
    
}
