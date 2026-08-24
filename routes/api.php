<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\AuthController;
use App\Http\Controllers\TradeController;
use App\Http\Controllers\DashboardController;

use App\Http\Controllers\Api\RiskSettingController;
use App\Http\Controllers\Api\GuardianController;
use App\Http\Controllers\Api\SignalController;
use App\Http\Controllers\Api\PlanController;
use App\Http\Controllers\Api\SubscriptionController;
use App\Http\Controllers\Api\PaymentController;
use App\Http\Controllers\Api\MarketAlertController;
use App\Http\Controllers\Api\CourseController;
use App\Http\Controllers\Api\LessonController;
use App\Http\Controllers\Api\DeviceTokenController;
use App\Http\Controllers\Api\UserSettingController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\TrialController;
// =====================================================================
// PUBLIC AUTH ROUTES
// =====================================================================

Route::post('/register', [
    AuthController::class,
    'register',
]);

Route::post('/login', [
    AuthController::class,
    'login',
]);

// =====================================================================
// GUARDIAN EA ROUTES
// =====================================================================

Route::post('/guardian/connect', [
    GuardianController::class,
    'connect',
]);

Route::post('/guardian/heartbeat', [
    GuardianController::class,
    'heartbeat',
]);

Route::get('/guardian/risk-settings', [
    GuardianController::class,
    'riskSettings',
]);

Route::post('/guardian/auto-trade/result', [
    GuardianController::class,
    'autoTradeResult',
]);


// =====================================================================
// AUTHENTICATED ROUTES
// =====================================================================

Route::middleware('auth:sanctum')->group(function () {

    // ================================================================
    // AUTH
    // ================================================================

    Route::post('/logout', [
        AuthController::class,
        'logout',
    ]);

    Route::get('/user', function (Request $request) {
        return response()->json([
            'user' => $request->user(),
        ]);
    });

    Route::put('/profile', [
    ProfileController::class,
    'update',
    ]);

    Route::get('/profile', [
    ProfileController::class,
    'show',
    ]);

    Route::put('/profile', [
    ProfileController::class,
    'update',
    ]);

    // ================================================================
    // TRADES
    // ================================================================

    Route::get('/trades', [
        TradeController::class,
        'index',
    ]);

    Route::post('/trades', [
        TradeController::class,
        'store',
    ]);

    Route::put('/trades/{trade}', [
        TradeController::class,
        'update',
    ]);

    Route::delete('/trades/{trade}', [
        TradeController::class,
        'destroy',
    ]);

    // ================================================================
    // DASHBOARD
    // ================================================================

    Route::get('/dashboard', [
        DashboardController::class,
        'index',
    ]);

    // ================================================================
    // SIGNALS
    // ================================================================

    Route::get('/signals', [
    SignalController::class,
    'index',
    ]);

    Route::get('/signals/{signal}', [
    SignalController::class,
    'show',
    ]);
    
    
    Route::post('/signals', [
        SignalController::class,
        'store',
    ]);

    Route::put('/signals/{signal}', [
        SignalController::class,
        'update',
    ]);

    Route::delete('/signals/{signal}', [
        SignalController::class,
        'destroy',
    ]);

    /*
    |--------------------------------------------------------------------------
    | Signal Workflow
    |--------------------------------------------------------------------------
    */

    Route::patch('/signals/{signal}/approve', [
        SignalController::class,
        'approve',
    ]);

    Route::patch('/signals/{signal}/reject', [
        SignalController::class,
        'reject',
    ]);

    Route::patch('/signals/{signal}/publish', [
        SignalController::class,
        'publish',
    ]);

    Route::patch('/signals/{signal}/start', [
        SignalController::class,
        'start',
    ]);

    Route::patch('/signals/{signal}/tp1', [
        SignalController::class,
        'tp1',
    ]);

    Route::patch('/signals/{signal}/tp2', [
        SignalController::class,
        'tp2',
    ]);

    Route::patch('/signals/{signal}/tp3', [
        SignalController::class,
        'tp3',
    ]);

    Route::patch('/signals/{signal}/close', [
        SignalController::class,
        'close',
    ]);

    Route::patch('/signals/{signal}/archive', [
        SignalController::class,
        'archive',
    ]);

    Route::get(
    '/signals/{signal}/ai-confirmation',
    [SignalController::class, 'aiConfirmation']
    );

    // ================================================================
    // RISK SETTINGS
    // ================================================================

    Route::get('/risk-settings', [
        RiskSettingController::class,
        'show',
    ]);

    Route::put('/risk-settings', [
        RiskSettingController::class,
        'update',
    ]);

    // ================================================================
    // GUARDIAN USER ROUTES
    // ================================================================

    Route::get('/guardian', [
        GuardianController::class,
        'show',
    ]);

    Route::post('/guardian/connection-code', [
        GuardianController::class,
        'generateConnectionCode',
    ]);

    Route::delete('/guardian/disconnect', [
        GuardianController::class,
        'disconnect',
    ]);

    // ================================================================
    // SUBSCRIPTION PLANS
    // ================================================================

    Route::get('/plans', [
        PlanController::class,
        'index',
    ]);

    Route::get('/plans/{plan}', [
        PlanController::class,
        'show',
    ]);

    // =================================================================
    // SUBSCRIPTIONS
    // =================================================================

    Route::get('/subscription', [
        SubscriptionController::class,
        'current',
    ]);

    Route::post('/subscription', [
        SubscriptionController::class,
        'subscribe',
    ]);
    
    // =================================================================
    // PAYMENTS
    // =================================================================

    Route::post('/payments/initialize', [
        PaymentController::class,
        'initialize',
    ]);

    Route::post('/payments/verify', [
    PaymentController::class,
    'verify',
    ]);

        // Payment History
    Route::get('/payments', [
        PaymentController::class,
        'index',
    ]);

    // Current payment
    Route::get('/payments/{payment}', [
        PaymentController::class,
        'show',
    ]);

    Route::post('/device-token', [
        DeviceTokenController::class,
        'store',
    ]);

    Route::delete('/device-token', [
        DeviceTokenController::class,
        'destroy',
    ]);

    Route::get('/settings', [UserSettingController::class, 'show']);
    Route::put('/settings/auto-trading', [UserSettingController::class, 'updateAutoTrading']);
    Route::put(
    '/settings/auto-trading/preferences',
    [UserSettingController::class, 'updatePreferences']
    );

    Route::post('/subscription/trial', [
    TrialController::class,
    'start',
    ]);

    Route::get('/subscription/trial', [
    TrialController::class,
    'current',
    ]);


});

// =================================================================
// PAYMENT WEBHOOKS
// =================================================================

Route::post('/payments/webhook', [
    PaymentController::class,
    'webhook',
]);

// ================================================================
// MARKET ALERTS
// ================================================================

    Route::get('/market-alerts', [
        MarketAlertController::class,
        'index',
    ]);

    Route::get('/market-alerts/{marketAlert}', [
        MarketAlertController::class,
        'show',
    ]);

    Route::post('/market-alerts', [
        MarketAlertController::class,
        'store',
    ]);

    Route::put('/market-alerts/{marketAlert}', [
        MarketAlertController::class,
        'update',
    ]);

    Route::delete('/market-alerts/{marketAlert}', [
        MarketAlertController::class,
        'destroy',
    ]);

    Route::get('/courses', [
    CourseController::class,
    'index',
    ]);

    Route::get('/courses/{course}', [
        CourseController::class,
        'show',
    ]);

    Route::get('/lessons/{lesson}', [
    LessonController::class,
    'show',
    ]);