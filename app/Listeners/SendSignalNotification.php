<?php

namespace App\Listeners;

use App\Events\SignalPublished;
use Illuminate\Support\Facades\Log;

class SendSignalNotification
{
    /**
     * Create the event listener.
     */
    public function __construct()
    {
        //
    }

    /**
     * Handle the event.
     */
    public function handle(SignalPublished $event): void
    {
        $signal = $event->signal;

        /*
        |--------------------------------------------------------------------------
        | Future Firebase Notification
        |--------------------------------------------------------------------------
        |
        | This listener will eventually:
        |
        | • Send FCM push notifications
        | • Send Email notifications
        | • Send Telegram alerts
        | • Send Discord alerts
        |
        */

        Log::info('Signal notification queued.', [
            'signal_id' => $signal->id,
            'symbol' => $signal->symbol?->name,
            'direction' => $signal->direction,
            'status' => $signal->status,
        ]);
    }
}