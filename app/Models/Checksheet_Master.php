<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Checksheet_Master extends Model
{
    protected $table = "checksheet_masters";
    protected $primaryKey = "master_id";
    public $incrementing = true;
    public $timestamp = false;
    protected $fillable = [
        'master_id',
        'no_ka',
        'name_ka',
        'tanggal_inspeksi',
        'status',
        'mekanik_id',
        'pengawas_id',
        'catatan_pengawas',
        'created_at',
        'submitted_at',
        'approved_at'
    ];
}
