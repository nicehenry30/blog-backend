<?php

namespace App\Services;

use App\Models\Signal;
use App\Models\SignalHistory;
use App\Models\User;

class SignalHistoryService
{
    /**
     * Record a signal event.
     */
    public function record(
        Signal $signal,
        ?User $user,
        string $event,
        ?string $oldStatus,
        ?string $newStatus,
        string $description,
        array $metadata = [],
    ): SignalHistory {

        return SignalHistory::create([
            'signal_id' => $signal->id,
            'user_id' => $user?->id,
            'event' => $event,
            'old_status' => $oldStatus,
            'new_status' => $newStatus,
            'description' => $description,
            'metadata' => $metadata,
        ]);
    }
}