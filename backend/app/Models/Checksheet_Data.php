<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Checksheet_Data extends Model
{
    protected $table = "checksheet__data";
    protected $primaryKey = "data_id";
    public $incrementing = true;
    public $timestamp = false;
    protected $fillable = [
        'data_id',
        'master_id',
        'name_sheet',
        'nomor_gerbong',
        'item_pemeriksa',
        'standar',
        'hasil_input',
        'keterangan'
    ];
}
