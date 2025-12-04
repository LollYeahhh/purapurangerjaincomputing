<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - MTIS</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #1e1e2f; }

        .layout {
            max-width: 1200px;
            margin: 20px auto;
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
            display: grid;
            grid-template-columns: 240px 1fr;
            min-height: 600px;
        }

        /* SIDEBAR */
        .sidebar {
            background: #222463;
            color: #fff;
            padding: 30px 20px;
        }

        .sidebar-logo {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            margin-bottom: 40px;
        }

        .sidebar-logo img { height: 60px; }

        .sidebar-menu h4 {
            font-size: 13px;
            margin-top: 25px;
            margin-bottom: 10px;
            opacity: .8;
        }

        .menu-item {
            padding: 10px 15px;
            border-radius: 8px;
            margin-bottom: 6px;
            font-size: 14px;
            cursor: pointer;
        }

        .menu-item.active {
            background: #0d6efd;
        }

        /* MAIN */
        .main {
            padding: 25px 30px;
            background: #f6f7fb;
        }

        .main-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 25px;
        }

        .card {
            background: #fff;
            padding: 15px 10px;
            border-radius: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }

        .card-label { font-size: 12px; margin-bottom: 8px; }
        .card-value { font-size: 22px; font-weight: bold; }

        /* POPUP LOGIN BERHASIL */
        .popup-bg {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.55);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 99;
        }

        .popup-box {
            background: #ffffff;
            width: 320px;
            border-radius: 12px;
            text-align: center;
            padding: 20px 25px;
            box-shadow: 0 10px 26px rgba(0,0,0,0.35);
            animation: fadeIn 0.2s ease-out;
        }

        .popup-title-ok {
            font-weight: bold;
            color: #27ae60;
            font-size: 18px;
            margin-bottom: 6px;
        }

        .popup-info-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 2px solid #27ae60;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 10px auto;
            font-weight: bold;
            color: #27ae60;
        }

        .popup-message {
            font-size: 14px;
            margin-bottom: 18px;
        }

        .popup-btn {
            background: #222463;
            color: #fff;
            padding: 8px 25px;
            border-radius: 20px;
            border: none;
            cursor: pointer;
            font-size: 13px;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.95); }
            to   { opacity: 1; transform: scale(1); }
        }
    </style>
</head>
<body>

<div class="layout">

    {{-- SIDEBAR --}}
    <aside class="sidebar">
        <div class="sidebar-logo">
            <img src="{{ asset('images/Logo_KAI01.png') }}" alt="KAI">
            <div>Admin</div>
        </div>

        <div class="sidebar-menu">
            <div class="menu-item active">Dashboard</div>
            <h4>Menu</h4>
            <div class="menu-item">Manajemen User</div>
            <div class="menu-item">Master Data</div>
            <div class="menu-item">Arsip Laporan</div>
            <div class="menu-item">Pengaturan</div>
        </div>
    </aside>

    {{-- MAIN CONTENT --}}
    <main class="main">
        <div class="main-header">
            <h2>Dashboard</h2>
            <div>Selamat datang, NIP: <strong>{{ $nip }}</strong></div>
        </div>

        <div class="cards">
            <div class="card">
                <div class="card-label">Total User</div>
                <div class="card-value">20</div>
            </div>
            <div class="card">
                <div class="card-label">Total Mekanik</div>
                <div class="card-value">20</div>
            </div>
            <div class="card">
                <div class="card-label">Total Pengawas</div>
                <div class="card-value">20</div>
            </div>
            <div class="card">
                <div class="card-label">Laporan Arsip</div>
                <div class="card-value">20</div>
            </div>
        </div>

        <h3>Manajemen User</h3>
        {{-- Di sini nanti kamu bisa lanjut buat tabel user sesuai desain Figma --}}
    </main>

</div>

{{-- POPUP LOGIN BERHASIL --}}
<div class="popup-bg" id="popup-success">
    <div class="popup-box">
        <div class="popup-info-icon">i</div>
        <div class="popup-title-ok">Login Berhasil</div>
        <div class="popup-message">
            Anda berhasil masuk ke sistem sebagai Admin.
        </div>
        <button class="popup-btn" onclick="closeSuccess()">OK</button>
    </div>
</div>

<script>
    function closeSuccess() {
        document.getElementById('popup-success').style.display = 'none';
    }

    // kalau baru saja login, tampilkan popup
    @if (session('login_success'))
        document.getElementById('popup-success').style.display = 'flex';
    @endif
</script>

</body>
</html>
