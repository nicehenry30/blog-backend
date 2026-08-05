<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Symbol extends Model
{
    use HasFactory;

    protected $fillable = [
        'symbol',
        'name',
        'asset_type',
        'broker_symbol',
        'digits',
        'active',
    ];

    protected $casts = [
        'active' => 'boolean',
        'digits' => 'integer',
    ];

    /**
     * A trading symbol has many signals.
     */
    public function signals(): HasMany
    {
        return $this->hasMany(Signal::class);
    }

    /**
     * Scope: only active symbols.
     */
    public function scopeActive($query)
    {
        return $query->where('active', true);
    }
}