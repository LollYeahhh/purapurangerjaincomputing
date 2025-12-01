<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Assignments extends Model
{
    protected $table = "assignments";
    protected $primaryKey = "jadwal_id";
    public $incrementing = true;
    public $timestamps = false;

    protected $fillable = [
        'jadwal_id',
        'user_id',
        'no_ka',
        'nama_ka',
        'jam_berangkat'
    ];
}
