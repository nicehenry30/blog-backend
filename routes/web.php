<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\SignalController;
use App\Http\Controllers\Admin\SymbolController;
use App\Http\Controllers\Admin\PlanController;
use App\Http\Controllers\Admin\SubscriptionController;
use App\Http\Controllers\Admin\PaymentController;
use App\Http\Controllers\Admin\MarketAlertController;
use App\Http\Controllers\PaymentCallbackController;
use App\Http\Controllers\Admin\CourseController;
use App\Http\Controllers\Admin\LessonController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Tradewisser Admin Panel
|
*/


Route::get('/', function () {
    return redirect('/admin');
});


Route::prefix('admin')->group(function () {

    /*
    |--------------------------------------------------------------------------
    | Dashboard
    |--------------------------------------------------------------------------
    */

    Route::get('/', [
        DashboardController::class,
        'index',
    ])->name('admin.dashboard');


    // =====================================================================
    // PLANS
    // =====================================================================

    Route::prefix('plans')->group(function () {

        Route::get('/', [
            PlanController::class,
            'index',
        ])->name('admin.plans.index');

        Route::get('/create', [
            PlanController::class,
            'create',
        ])->name('admin.plans.create');

        Route::post('/', [
            PlanController::class,
            'store',
        ])->name('admin.plans.store');

        Route::get('/{plan}', [
            PlanController::class,
            'show',
        ])->name('admin.plans.show');

        Route::get('/{plan}/edit', [
            PlanController::class,
            'edit',
        ])->name('admin.plans.edit');

        Route::put('/{plan}', [
            PlanController::class,
            'update',
        ])->name('admin.plans.update');

        Route::delete('/{plan}', [
            PlanController::class,
            'destroy',
        ])->name('admin.plans.destroy');

    });


    // =====================================================================
    // SIGNALS
    // =====================================================================

    Route::prefix('signals')->group(function () {

        Route::get('/', [
            SignalController::class,
            'index',
        ])->name('admin.signals.index');

        Route::get('/create', [
            SignalController::class,
            'create',
        ])->name('admin.signals.create');

        Route::post('/', [
            SignalController::class,
            'store',
        ])->name('admin.signals.store');

        Route::get('/{signal}', [
            SignalController::class,
            'show',
        ])->name('admin.signals.show');

        Route::get('/{signal}/edit', [
            SignalController::class,
            'edit',
        ])->name('admin.signals.edit');

        Route::put('/{signal}', [
            SignalController::class,
            'update',
        ])->name('admin.signals.update');

        Route::delete('/{signal}', [
            SignalController::class,
            'destroy',
        ])->name('admin.signals.destroy');


        // Signal Workflow

        Route::patch('/{signal}/approve', [
            SignalController::class,
            'approve',
        ])->name('admin.signals.approve');

        Route::patch('/{signal}/reject', [
            SignalController::class,
            'reject',
        ])->name('admin.signals.reject');

        Route::patch('/{signal}/publish', [
            SignalController::class,
            'publish',
        ])->name('admin.signals.publish');

        Route::patch('/{signal}/start', [
            SignalController::class,
            'start',
        ])->name('admin.signals.start');

        Route::patch('/{signal}/tp1', [
            SignalController::class,
            'tp1',
        ])->name('admin.signals.tp1');

        Route::patch('/{signal}/tp2', [
            SignalController::class,
            'tp2',
        ])->name('admin.signals.tp2');

        Route::patch('/{signal}/tp3', [
            SignalController::class,
            'tp3',
        ])->name('admin.signals.tp3');

        Route::get(
            '/{signal}/close',
            [SignalController::class, 'closeForm']
        )->name('admin.signals.close-form');

        Route::patch('/{signal}/close', [
            SignalController::class,
            'close',
        ])->name('admin.signals.close');

        Route::patch('/{signal}/archive', [
            SignalController::class,
            'archive',
        ])->name('admin.signals.archive');

    });


    // =====================================================================
    // SUBSCRIPTIONS
    // =====================================================================

    Route::prefix('subscriptions')->group(function () {

        Route::get('/', [
            SubscriptionController::class,
            'index',
        ])->name('admin.subscriptions.index');

        Route::get('/{subscription}', [
            SubscriptionController::class,
            'show',
        ])->name('admin.subscriptions.show');

        Route::get('/{subscription}/edit', [
            SubscriptionController::class,
            'edit',
        ])->name('admin.subscriptions.edit');

        Route::put('/{subscription}', [
            SubscriptionController::class,
            'update',
        ])->name('admin.subscriptions.update');

        Route::delete('/{subscription}', [
            SubscriptionController::class,
            'destroy',
        ])->name('admin.subscriptions.destroy');

    });


    // =====================================================================
    // PAYMENTS
    // =====================================================================

    Route::prefix('payments')->group(function () {

        Route::get('/', [
            PaymentController::class,
            'index',
        ])->name('admin.payments.index');

        Route::get('/{payment}', [
            PaymentController::class,
            'show',
        ])->name('admin.payments.show');

        Route::get('/{payment}/edit', [
            PaymentController::class,
            'edit',
        ])->name('admin.payments.edit');

        Route::put('/{payment}', [
            PaymentController::class,
            'update',
        ])->name('admin.payments.update');

        Route::delete('/{payment}', [
            PaymentController::class,
            'destroy',
        ])->name('admin.payments.destroy');

    });


    // =====================================================================
    // MARKET ALERTS
    // =====================================================================

    Route::prefix('market-alerts')->group(function () {

        Route::get('/', [
            MarketAlertController::class,
            'index',
        ])->name('admin.market-alerts.index');

        Route::get('/create', [
            MarketAlertController::class,
            'create',
        ])->name('admin.market-alerts.create');

        Route::post('/', [
            MarketAlertController::class,
            'store',
        ])->name('admin.market-alerts.store');

        Route::get('/{marketAlert}', [
            MarketAlertController::class,
            'show',
        ])->name('admin.market-alerts.show');

        Route::get('/{marketAlert}/edit', [
            MarketAlertController::class,
            'edit',
        ])->name('admin.market-alerts.edit');

        Route::put('/{marketAlert}', [
            MarketAlertController::class,
            'update',
        ])->name('admin.market-alerts.update');

        Route::delete('/{marketAlert}', [
            MarketAlertController::class,
            'destroy',
        ])->name('admin.market-alerts.destroy');

    });

    // =====================================================================
    // COURSES
    // =====================================================================

    Route::prefix('courses')->group(function () {

        Route::get('/', [
            CourseController::class,
            'index',
        ])->name('admin.courses.index');

        Route::get('/create', [
            CourseController::class,
            'create',
        ])->name('admin.courses.create');

        Route::post('/', [
            CourseController::class,
            'store',
        ])->name('admin.courses.store');

        Route::get('/{course}', [
            CourseController::class,
            'show',
        ])->name('admin.courses.show');

        Route::get('/{course}/edit', [
            CourseController::class,
            'edit',
        ])->name('admin.courses.edit');

        Route::put('/{course}', [
            CourseController::class,
            'update',
        ])->name('admin.courses.update');

        Route::delete('/{course}', [
            CourseController::class,
            'destroy',
        ])->name('admin.courses.destroy');

    });

    // =====================================================================
    // LESSONS
    // =====================================================================

    Route::prefix('lessons')->group(function () {

        Route::get('/', [
            LessonController::class,
            'index',
        ])->name('admin.lessons.index');

        Route::get('/create', [
            LessonController::class,
            'create',
        ])->name('admin.lessons.create');

        Route::post('/', [
            LessonController::class,
            'store',
        ])->name('admin.lessons.store');

        Route::get('/{lesson}', [
            LessonController::class,
            'show',
        ])->name('admin.lessons.show');

        Route::get('/{lesson}/edit', [
            LessonController::class,
            'edit',
        ])->name('admin.lessons.edit');

        Route::put('/{lesson}', [
            LessonController::class,
            'update',
        ])->name('admin.lessons.update');

        Route::delete('/{lesson}', [
            LessonController::class,
            'destroy',
        ])->name('admin.lessons.destroy');

    });
    // =====================================================================
    // TRADING SYMBOLS
    // =====================================================================

    Route::prefix('symbols')->group(function () {

        Route::get('/', [
            SymbolController::class,
            'index',
        ])->name('admin.symbols.index');

        Route::get('/create', [
            SymbolController::class,
            'create',
        ])->name('admin.symbols.create');

        Route::post('/', [
            SymbolController::class,
            'store',
        ])->name('admin.symbols.store');

        Route::get('/{symbol}/edit', [
            SymbolController::class,
            'edit',
        ])->name('admin.symbols.edit');

        Route::put('/{symbol}', [
            SymbolController::class,
            'update',
        ])->name('admin.symbols.update');

        Route::delete('/{symbol}', [
            SymbolController::class,
            'destroy',
        ])->name('admin.symbols.destroy');

    });




});

    // =====================================================================
    // PAYMENT CALLBACK
    // =====================================================================

    Route::get('/payment/callback', [
        PaymentCallbackController::class,
        'handle',
    ])->name('payment.callback');