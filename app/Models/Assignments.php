<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\Checksheet_Master;

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
        'jam_berangkat',
    ];

    public function checksheet()
    {
        return $this->hasOne(\App\Models\Checksheet_Master::class, 'no_ka', 'no_ka');
    }
}
