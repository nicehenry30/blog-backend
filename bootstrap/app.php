<?php

use App\Http\Middleware\AdminMiddleware;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Console\Scheduling\Schedule;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
       ->withSchedule(function (Schedule $schedule): void {
        $schedule->command('news:ingest --limit=20')
            ->everyFifteenMinutes()
            ->withoutOverlapping();

        $schedule->command('finance-calendar:sync --country=US,GB --impact=high --limit=50')
            ->everyFifteenMinutes()
            ->withoutOverlapping();
    })
    ->withMiddleware(function (Middleware $middleware): void {

    /*
    |--------------------------------------------------------------------------
    | Admin Middleware
    |--------------------------------------------------------------------------
    */

        $middleware->alias([
            'admin' => AdminMiddleware::class,
        ]);

    $middleware->redirectGuestsTo(function ($request) {
        return route('admin.login');
        });

    })
    ->withExceptions(function (Exceptions $exceptions): void {

        $exceptions->render(function (
            AuthenticationException $e,
            $request
        ) {
            if ($request->is('api/*')) {
                return response()->json([
                    'message' => 'Unauthenticated.',
                ], 401);
            }
        });

    })
    ->create();