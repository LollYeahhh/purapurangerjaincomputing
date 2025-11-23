<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Laporan_PDF extends Model
{
    protected $table = "laporan_p_d_f_s";
    protected $primaryKey = "pdf_id";
    public $incrementing = true;
    public $timestamp = false;
    protected $fillable = [
        'master_id',
        'file_url',
        'generated_at',
        'expiry_date',
    ];
}
