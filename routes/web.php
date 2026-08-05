<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\SignalController;
use App\Http\Controllers\Admin\SymbolController;
use App\Http\Controllers\Admin\PlanController;
use App\Http\Controllers\Admin\SubscriptionController;
use App\Http\Controllers\Admin\PaymentController;
use App\Http\Controllers\PaymentCallbackController;

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

    /*
    |--------------------------------------------------------------------------
    | Signals
    |--------------------------------------------------------------------------
    */

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

    /*
|--------------------------------------------------------------------------
| Signals
|--------------------------------------------------------------------------
*/

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

        Route::patch('/{signal}/publish', [
            SignalController::class,
            'publish',
        ])->name('admin.signals.publish');

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
        
    /*
    |--------------------------------------------------------------------------
    | Trading Symbols
    |--------------------------------------------------------------------------
    */

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


    Route::get('/payment/callback', [
        PaymentCallbackController::class,
        'handle',
    ])->name('payment.callback');

});