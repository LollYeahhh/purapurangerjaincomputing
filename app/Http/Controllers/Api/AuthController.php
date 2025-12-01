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
            'message' => 'Anda telah berhasil logout.'
        ]);
    }
        
    public function APIChangePassword (Request $request){
       $passwordData = $request->validate([
            'current_password' => 'required|string',
            'new_password' => 'required|string|min:8',
            'new_password_confirmation' => 'required|string'
       ]);
       $user = User::where('nipp', $request->user()->nipp)->first();
       if(!$user || !Hash::check($passwordData['current_password'], $user->password_hash)){
            return response()->json([
                'status' => 'error',
                'message' => 'password lama tidak sesuai',
                'errors' => 'current_password'
            ],422);
       }
       //cek password lama
       if($passwordData['new_password'] != $passwordData['new_password_confirmation']){
            return response()->json([
                'status' => 'error',
                'message' => 'password baru tidak sesuai',
                'errors' => 'new_password'
            ],422);
       }
       //cegah password baru sama dengan password lama
        if (Hash::check($passwordData['new_password'], $user->password_hash)) {
             return response()->json([
                'status'  => 'error',
                'message' => 'Password baru tidak boleh sama dengan password lama',
                'errors'  => 'new_password'
             ],422);
        }  
        $user->password_hash = Hash::make($passwordData['new_password']);
        $user->save();

        return response()->json([
            'status' => 'success',
            'message' => 'password berhasil diperbarui'
        ],200);
    }
    
}
