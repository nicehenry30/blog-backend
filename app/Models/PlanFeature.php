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
    | Signal Features
    |--------------------------------------------------------------------------
    */

    public const VIEW_FREE_SIGNALS = 'view_free_signals';
    public const VIEW_PREMIUM_SIGNALS = 'view_premium_signals';
    public const VIEW_PRO_SIGNALS = 'view_pro_signals';
    public const DAILY_SIGNAL_LIMIT = 'daily_signal_limit';
    public const SIGNAL_HISTORY = 'signal_history';
    public const TP_TRACKING = 'tp_tracking';

    /*
    |--------------------------------------------------------------------------
    | Education
    |--------------------------------------------------------------------------
    */

    public const BASIC_COURSES = 'basic_courses';
    public const PREMIUM_COURSES = 'premium_courses';

    /*
    |--------------------------------------------------------------------------
    | Journal
    |--------------------------------------------------------------------------
    */

    public const JOURNAL = 'journal';
    public const JOURNAL_LIMIT = 'journal_limit';

    /*
    |--------------------------------------------------------------------------
    | Guardian
    |--------------------------------------------------------------------------
    */

    public const GUARDIAN_MT4 = 'guardian_mt4';
    public const GUARDIAN_MT5 = 'guardian_mt5';
    public const GUARDIAN_ACCOUNTS = 'guardian_accounts';

    /*
    |--------------------------------------------------------------------------
    | AI
    |--------------------------------------------------------------------------
    */

    public const AI_SIGNAL_ANALYSIS = 'ai_signal_analysis';
    public const AI_TRADING_COACH = 'ai_trading_coach';
    public const AI_REQUEST_LIMIT = 'ai_request_limit';

    /*
    |--------------------------------------------------------------------------
    | Notifications
    |--------------------------------------------------------------------------
    */

    public const PUSH_NOTIFICATIONS = 'push_notifications';
    public const EMAIL_NOTIFICATIONS = 'email_notifications';

    /*
    |--------------------------------------------------------------------------
    | Support
    |--------------------------------------------------------------------------
    */

    public const PRIORITY_SUPPORT = 'priority_support';

    protected $fillable = [

        'plan_id',

        'feature',

        'enabled',

        'value',

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