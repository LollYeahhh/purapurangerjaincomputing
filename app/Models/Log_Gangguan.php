<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Log_Gangguan extends Model
{
    protected $table = "log_gangguans";
    protected $primaryKey = "gangguan_id";
    public $incrementing = true;
    public $timestamp = false;
    protected $fillable = [
        'master_id',
        'identitas_komponen',
        'bentuk_gangguan',
        'tidak_lanjut',
        'waktu_lapor'
    ];
}
