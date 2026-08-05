<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Signal extends Model
{
    use HasFactory;

    protected $fillable = [
        'symbol_id',
        'direction',
        'entry_price',
        'stop_loss',
        'take_profit',
        'take_profit_2',
        'take_profit_3',
        'timeframe',
        'signal_quality',
        'overall_confidence',
        'strategy',
        'risk_reward',
        'analysis',
        'confluences',
        'chart_image',
        'status',
        'ai_score',
        'ai_comment',
        'published_at',
        'approved_at',
        'closed_at',
        'result',
        'pips',
        'created_by',
        'approved_by',
    ];

    protected $casts = [
        'entry_price' => 'decimal:5',
        'stop_loss' => 'decimal:5',
        'take_profit' => 'decimal:5',
        'take_profit_2' => 'decimal:5',
        'take_profit_3' => 'decimal:5',
        'signal_quality' => 'decimal:2',
        'overall_confidence' => 'decimal:2',
        'risk_reward' => 'decimal:2',
        'confluences' => 'array',
        'published_at' => 'datetime',
        'approved_at' => 'datetime',
        'closed_at' => 'datetime',
    ];

    /*
    |--------------------------------------------------------------------------
    | Relationships
    |--------------------------------------------------------------------------
    */

    public function symbol(): BelongsTo
    {
        return $this->belongsTo(Symbol::class);
    }

    public function creator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    public function approver(): BelongsTo
    {
        return $this->belongsTo(User::class, 'approved_by');
    }

    /**
     * Signal History
     */
    public function histories(): HasMany
    {
        return $this->hasMany(SignalHistory::class)
            ->latest();
    }

    /*
    |--------------------------------------------------------------------------
    | Status Helpers
    |--------------------------------------------------------------------------
    */

    public function isPublished(): bool
    {
        return $this->status === 'Published';
    }

    public function isApproved(): bool
    {
        return $this->status === 'Approved';
    }

    public function isRunning(): bool
    {
        return $this->status === 'Running';
    }

    public function isClosed(): bool
    {
        return $this->status === 'Closed';
    }

    /*
    |--------------------------------------------------------------------------
    | Workflow Methods
    |--------------------------------------------------------------------------
    */

    public function approve(User $user): void
    {
        $this->update([
            'status' => 'Approved',
            'approved_by' => $user->id,
            'approved_at' => now(),
        ]);
    }

    public function publish(): void
    {
        $this->update([
            'status' => 'Published',
            'published_at' => now(),
        ]);
    }

    public function start(): void
    {
        $this->update([
            'status' => 'Running',
        ]);
    }

    public function markTp1(): void
    {
        $this->update([
            'status' => 'TP1 Hit',
        ]);
    }

    public function markTp2(): void
    {
        $this->update([
            'status' => 'TP2 Hit',
        ]);
    }

    public function markTp3(): void
    {
        $this->update([
            'status' => 'TP3 Hit',
        ]);
    }

    public function close(
        string $result,
        int $pips
    ): void {
        $this->update([
            'status' => 'Closed',
            'result' => $result,
            'pips' => $pips,
            'closed_at' => now(),
        ]);
    }

    public function reject(): void
    {
        $this->update([
            'status' => 'Rejected',
        ]);
    }

    public function cancel(): void
    {
        $this->update([
            'status' => 'Cancelled',
        ]);
    }

    public function expire(): void
    {
        $this->update([
            'status' => 'Expired',
        ]);
    }
}