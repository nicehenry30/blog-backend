<?php

namespace App\Listeners;

use App\Events\SignalPublished;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;

class RecordPublishedHistory
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
        //
    }
}
