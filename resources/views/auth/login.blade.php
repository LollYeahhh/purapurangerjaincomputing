<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>LOGIN - MOBILE TRAIN INSPECTION SYSTEM</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #1e1e2f; }

        .container {
            max-width: 1000px;
            margin: 40px auto;
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
        }

        .header {
            background: #fff;
            padding: 25px 40px;
            border-bottom: 4px solid #f58634;
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .header img { height: 50px; }
        .header-title { font-weight: bold; font-size: 20px; }

        .main {
            background: #222463;
            padding: 70px 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-box {
            background: #fff;
            padding: 40px 60px;
            border-radius: 18px;
            width: 460px;
            text-align: center;
            box-shadow: 0 10px 26px rgba(0,0,0,0.28);
        }

        .login-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .input {
            width: 100%;
            padding: 12px 20px;
            border-radius: 30px;
            border: 1px solid #aaa;
            font-size: 14px;
        }

        .password-wrapper {
            position: relative;
            margin-top: 18px;
            margin-bottom: 6px;
        }

        .password-wrapper .input {
            padding-right: 56px;
        }

        .toggle-password {
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            padding: 0;
            background: transparent;
            border: none;
        }

        .toggle-password svg {
            width: 22px;
            height: 22px;
            stroke: #555;
        }

        .forgot {
            text-align: right;
            margin-bottom: 20px;
        }

        .forgot a {
            font-size: 12px;
            color: #f58634;
            text-decoration: none;
        }

        .btn {
            width: 100%;
            padding: 12px;
            border-radius: 30px;
            border: none;
            background: #222463;
            color: #fff;
            font-weight: bold;
            cursor: pointer;
            font-size: 14px;
        }

        /* POPUP GAGAL */
        .popup-bg {
            position: fixed;
            top: 0; left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.55);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 99;
        }

        .popup-box {
            background: white;
            padding: 20px 25px;
            width: 300px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 10px 26px rgba(0,0,0,0.35);
            animation: fadeIn 0.2s ease-out;
        }

        .popup-title {
            font-weight: bold;
            font-size: 17px;
            color: #c0392b;
            margin-bottom: 10px;
        }

        .popup-message {
            font-size: 14px;
            margin-bottom: 20px;
        }

        .popup-btn {
            background: #222463;
            color: #fff;
            padding: 10px 25px;
            border-radius: 20px;
            border: none;
            cursor: pointer;
            font-size: 13px;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }
    </style>
</head>
<body>

<div class="container">

    <div class="header">
        <img src="{{ asset('images/Logo_KAI01.png') }}" alt="KAI">
        <div class="header-title">MOBILE TRAIN INSPECTION SYSTEM</div>
    </div>

    <div class="main">
        <div class="login-box">
            <div class="login-title">LOGIN</div>

            <form method="POST" action="{{ route('login.submit') }}">
                @csrf

                <input
                    type="text"
                    name="nip"
                    value="{{ old('nip') }}"
                    placeholder="Masukkan NIP"
                    class="input">

                <div class="password-wrapper">
                    <input
                        type="password"
                        name="password"
                        id="password-field"
                        placeholder="Password"
                        class="input">

                    <button type="button" class="toggle-password" onclick="togglePassword()">
                        {{-- eye-open = password terlihat --}}
                        <svg id="eye-open" style="display:none;" xmlns="http://www.w3.org/2000/svg" fill="none"
                             viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                  d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943 9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                            <circle cx="12" cy="12" r="3" />
                        </svg>

                        {{-- eye-off = password disembunyikan --}}
                        <svg id="eye-off" xmlns="http://www.w3.org/2000/svg" fill="none"
                             viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                  d="M3 3l18 18M10.584 10.585A3 3 0 0113.415 13.415M6.343 6.343C4.928 7.768 4 9.776 4 12c0 .835.152 1.635.433 2.38M12 5c4.477 0 8.268 2.943 9.542 7-.363 1.16-.94 2.22-1.687 3.127M9.88 9.88A3 3 0 0114.12 14.12" />
                        </svg>
                    </button>
                </div>

                <div class="forgot"><a href="#">Lupa Password ?</a></div>

                <button class="btn">MASUK</button>
            </form>

        </div>
    </div>

</div>

{{-- POPUP LOGIN GAGAL --}}
<div class="popup-bg" id="popup">
    <div class="popup-box">
        <div class="popup-title">Login Gagal</div>
        <div class="popup-message" id="popup-message"></div>
        <button class="popup-btn" onclick="closePopup()">OK</button>
    </div>
</div>

<script>
    function togglePassword() {
        const input   = document.getElementById('password-field');
        const eyeOpen = document.getElementById('eye-open');
        const eyeOff  = document.getElementById('eye-off');

        if (input.type === "password") {
            input.type = "text";      // show password
            eyeOpen.style.display = "block";
            eyeOff.style.display  = "none";
        } else {
            input.type = "password";  // hide password
            eyeOpen.style.display = "none";
            eyeOff.style.display  = "block";
        }
    }

    function closePopup() {
        document.getElementById("popup").style.display = "none";
    }

    // --- Tampilkan popup bila ada error dari Laravel ---
    @if (session('login_error_message'))
        document.getElementById("popup-message").innerText =
            "{{ session('login_error_message') }}";
        document.getElementById("popup").style.display = "flex";
    @endif

    @if ($errors->any())
        let msg = "";
        @foreach ($errors->all() as $err)
            msg += "{{ $err }}\n";
        @endforeach
        document.getElementById("popup-message").innerText = msg;
        document.getElementById("popup").style.display = "flex";
    @endif
</script>

</body>
</html>
