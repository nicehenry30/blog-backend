<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PlanFeature extends Model
{
    use HasFactory;

    /*
    |--------------------------------------------------------------------------
    | Feature Constants
    |--------------------------------------------------------------------------
    */

    public const DELAYED_SIGNALS = 'delayed_signals';
    public const LIVE_SIGNALS = 'live_signals';
    public const EDUCATION = 'education';
    public const JOURNAL = 'journal';
    public const DASHBOARD = 'dashboard';
    public const PUSH_NOTIFICATIONS = 'push_notifications';
    public const GUARDIAN = 'guardian';
    public const AI_COACH = 'ai_coach';
    public const PRIORITY_SUPPORT = 'priority_support';

    protected $fillable = [
        'plan_id',
        'feature',
        'enabled',
    ];

    protected $casts = [
        'enabled' => 'boolean',
    ];

    /**
     * Plan that owns this feature.
     */
    public function plan(): BelongsTo
    {
        return $this->belongsTo(Plan::class);
    }
}