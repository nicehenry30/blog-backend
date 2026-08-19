<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Signal extends Model
{
    use HasFactory;

        /*
    |--------------------------------------------------------------------------
    | Signal Status Constants
    |--------------------------------------------------------------------------
    */

    public const STATUS_DRAFT = 'Draft';

    public const STATUS_APPROVED = 'Approved';

    public const STATUS_PUBLISHED = 'Published';

    public const STATUS_RUNNING = 'Running';

    public const STATUS_CLOSED = 'Closed';

    public const STATUS_REJECTED = 'Rejected';

    public const STATUS_CANCELLED = 'Cancelled';

    public const STATUS_EXPIRED = 'Expired';

    /*
    |--------------------------------------------------------------------------
    | Workflow Statuses
    |--------------------------------------------------------------------------
    */

  /*
|--------------------------------------------------------------------------
| Workflow Statuses
|--------------------------------------------------------------------------
*/

    public const WORKFLOW_STATUSES = [

        self::STATUS_DRAFT,

        self::STATUS_APPROVED,

        self::STATUS_PUBLISHED,

        self::STATUS_RUNNING,

        self::STATUS_CLOSED,

        self::STATUS_REJECTED,

        self::STATUS_CANCELLED,

        self::STATUS_EXPIRED,

    ];
    /**
     * Available workflow statuses.
     */
    public static function statuses(): array
    {
        return self::WORKFLOW_STATUSES;
    }

/*
|--------------------------------------------------------------------------
| Default Relationships
|--------------------------------------------------------------------------
*/

    public const DEFAULT_RELATIONS = [

        'symbol',

        'creator',

        'approver',

        'histories',

    ];

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

        'visibility',

        'auto_executable',

        'ai_score',

        'ai_comment',

        'published_at',

        'approved_at',

        'closed_at',

        'tp1_hit_at',

        'tp2_hit_at',

        'tp3_hit_at',

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

        'auto_executable' => 'boolean',

        'published_at' => 'datetime',

        'approved_at' => 'datetime',

        'closed_at' => 'datetime',

        'tp1_hit_at' => 'datetime',

        'tp2_hit_at' => 'datetime',

        'tp3_hit_at' => 'datetime',

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
        return $this->status === self::STATUS_PUBLISHED;
    }

    public function isApproved(): bool
    {
        return $this->status === self::STATUS_APPROVED;
    }

    public function isRunning(): bool
    {
        return $this->status === self::STATUS_RUNNING;
    }

    public function isClosed(): bool
    {
        return $this->status === self::STATUS_CLOSED;
    }
    /*
    |--------------------------------------------------------------------------
    | Workflow Methods
    |--------------------------------------------------------------------------
    */

    public function approve(User $user): void
    {
        $this->update([
            'status' => self::STATUS_APPROVED,
            'approved_by' => $user->id,
            'approved_at' => now(),
        ]);
    }

    public function publish(): void
    {
        $this->update([
            'status' => self::STATUS_PUBLISHED,
            'published_at' => now(),
        ]);
    }

    public function start(): void
    {
        $this->update([
            'status' => self::STATUS_RUNNING,
        ]);
    }

        /**
     * Mark Take Profit 1 as reached.
     */
    public function markTp1(): void
    {
        $this->update([
            'tp1_hit_at' => now(),
        ]);
    }

    /**
     * Mark Take Profit 2 as reached.
     */
    public function markTp2(): void
    {
        $this->update([
            'tp2_hit_at' => now(),
        ]);
    }

    /**
     * Mark Take Profit 3 as reached.
     */
    public function markTp3(): void
    {
        $this->update([
            'tp3_hit_at' => now(),
        ]);
    }

    public function close(
        string $result,
        int $pips
    ): void {
        $this->update([
            'status' => self::STATUS_CLOSED,
            'result' => $result,
            'pips' => $pips,
            'closed_at' => now(),
        ]);
    }

    public function reject(): void
    {
        $this->update([
            'status' => self::STATUS_REJECTED,
        ]);
    }

    public function cancel(): void
    {
        $this->update([
            'status' => self::STATUS_CANCELLED,
        ]);
    }

    public function expire(): void
    {
        $this->update([
            'status' => self::STATUS_EXPIRED,
        ]);
    }
}