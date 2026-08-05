<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SignalHistory extends Model
{
    use HasFactory;

    protected $fillable = [
        'signal_id',
        'user_id',
        'event',
        'old_status',
        'new_status',
        'description',
        'metadata',
    ];

    protected $casts = [
        'metadata' => 'array',
    ];

    /**
     * Signal
     */
    public function signal(): BelongsTo
    {
        return $this->belongsTo(Signal::class);
    }

    /**
     * User
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}