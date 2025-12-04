<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class AuthController extends Controller
{
    public function showLoginForm()
    {
        return view('auth.login');
    }

    public function login(Request $request)
    {
        // 1. Validasi form
        $request->validate(
            [
                'nip'      => 'required',
                'password' => 'required',
            ],
            [
                'nip.required'      => 'NIP belum diisi.',
                'password.required' => 'Password belum diisi.',
            ]
        );

        // ==========================
        // SIMULASI DATA USER
        // ==========================
        $validNip      = 'admin';   // contoh NIP benar
        $validPassword = '12345';   // contoh password benar
        $userRole      = 'admin';   // ubah ke 'mekanik' / 'pengawas' untuk tes popup ke-3

        // --- POPUP GAGAL 1: NIP belum terdaftar ---
        if ($request->nip !== $validNip) {
            return back()
                ->with('login_error_message', 'Login Gagal. NIP belum terdaftar.')
                ->withInput();
        }

        // --- POPUP GAGAL 3: NIP & Password benar tapi role bukan Admin ---
        if ($request->nip === $validNip &&
            $request->password === $validPassword &&
            $userRole !== 'admin') {

            return back()
                ->with('login_error_message', 'Login Gagal. NIP dan Password benar tapi pengguna bukan role sebagai Admin.')
                ->withInput();
        }

        // --- POPUP GAGAL 2: NIP terdaftar tapi password salah ---
        if ($request->password !== $validPassword) {
            return back()
                ->with('login_error_message', 'Login Gagal. NIP atau Password tidak sesuai.')
                ->withInput();
        }

        // ==========================
        // LOGIN BERHASIL
        // ==========================
        // Simpan NIP ke session untuk ditampilkan di dashboard
        $request->session()->put('user_nip', $request->nip);

        return redirect()
            ->route('dashboard')
            ->with('login_success', true);
    }

    // Halaman dashboard
    public function dashboard(Request $request)
    {
        $nip = $request->session()->get('user_nip', '-');

        return view('dashboard', compact('nip'));
    }
}
