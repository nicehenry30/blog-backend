<?php

namespace App\Events;

use App\Models\Signal;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class SignalPublished
{
    use Dispatchable, SerializesModels;

    /**
     * The published signal.
     */
    public Signal $signal;

    /**
     * Create a new event instance.
     */
    public function __construct(Signal $signal)
    {
        $this->signal = $signal;
    }
}