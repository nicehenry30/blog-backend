<?php

namespace App\Services;

use App\Models\Signal;
use App\Models\User;

class SignalWorkflowService
{
    public function __construct(
        protected SignalHistoryService $historyService,
    ) {
    }

    /**
     * Common workflow handler.
     */
    protected function changeStatus(
        Signal $signal,
        ?User $user,
        string $newStatus,
        string $event,
        string $description,
        array $extra = [],
    ): void {

        $oldStatus = $signal->status;

        $signal->update(
            array_merge([
                'status' => $newStatus,
            ], $extra)
        );

        $this->historyService->record(
            signal: $signal,
            user: $user,
            event: $event,
            oldStatus: $oldStatus,
            newStatus: $newStatus,
            description: $description,
        );
    }

    /*
    |--------------------------------------------------------------------------
    | Workflow Methods
    |--------------------------------------------------------------------------
    */

    public function approve(
        Signal $signal,
        User $user,
    ): void {

        $this->changeStatus(
            signal: $signal,
            user: $user,
            newStatus: 'Approved',
            event: 'approved',
            description: 'Signal approved.',
            extra: [
                'approved_by' => $user->id,
                'approved_at' => now(),
            ],
        );
    }

    public function publish(
        Signal $signal,
        User $user,
    ): void {

        $this->changeStatus(
            signal: $signal,
            user: $user,
            newStatus: 'Published',
            event: 'published',
            description: 'Signal published.',
            extra: [
                'published_at' => now(),
            ],
        );
    }

    public function reject(
        Signal $signal,
        User $user,
    ): void {

        $this->changeStatus(
            signal: $signal,
            user: $user,
            newStatus: 'Rejected',
            event: 'rejected',
            description: 'Signal rejected.',
        );
    }

    public function start(
        Signal $signal,
        User $user,
    ): void {

        $this->changeStatus(
            signal: $signal,
            user: $user,
            newStatus: 'Running',
            event: 'started',
            description: 'Trade is now running.',
        );
    }

    public function tp1(
        Signal $signal,
        User $user,
    ): void {

        $this->changeStatus(
            signal: $signal,
            user: $user,
            newStatus: 'TP1 Hit',
            event: 'tp1_hit',
            description: 'Take Profit 1 reached.',
        );
    }

    public function tp2(
        Signal $signal,
        User $user,
    ): void {

        $this->changeStatus(
            signal: $signal,
            user: $user,
            newStatus: 'TP2 Hit',
            event: 'tp2_hit',
            description: 'Take Profit 2 reached.',
        );
    }

    public function tp3(
        Signal $signal,
        User $user,
    ): void {

        $this->changeStatus(
            signal: $signal,
            user: $user,
            newStatus: 'TP3 Hit',
            event: 'tp3_hit',
            description: 'Take Profit 3 reached.',
        );
    }

    public function close(
        Signal $signal,
        User $user,
        string $result,
        int $pips,
    ): void {

        $this->changeStatus(
            signal: $signal,
            user: $user,
            newStatus: 'Closed',
            event: 'closed',
            description: "Trade closed as {$result}.",
            extra: [
                'result' => $result,
                'pips' => $pips,
                'closed_at' => now(),
            ],
        );
    }

    public function cancel(
        Signal $signal,
        User $user,
    ): void {

        $this->changeStatus(
            signal: $signal,
            user: $user,
            newStatus: 'Cancelled',
            event: 'cancelled',
            description: 'Signal cancelled.',
        );
    }

    public function expire(
        Signal $signal,
        User $user,
    ): void {

        $this->changeStatus(
            signal: $signal,
            user: $user,
            newStatus: 'Expired',
            event: 'expired',
            description: 'Signal expired.',
        );
    }
}