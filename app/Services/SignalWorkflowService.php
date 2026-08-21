<?php

namespace App\Services;

use App\Models\Signal;
use App\Models\User;
use Illuminate\Validation\ValidationException;

class SignalWorkflowService
{
    public function __construct(
        protected SignalHistoryService $historyService,
        protected SignalAiConfirmationService $aiConfirmationService,
    ) {
    }

    /**
     * Approve Signal.
     */
    public function approve(
        Signal $signal,
        User $user
    ): void {
        $oldStatus = $signal->status;

        $signal->approve($user);

        $this->historyService->record(
            signal: $signal,
            user: $user,
            event: 'approved',
            oldStatus: $oldStatus,
            newStatus: Signal::STATUS_APPROVED,
            description: 'Signal approved.',
        );
    }

    /**
     * Reject Signal.
     */
    public function reject(
        Signal $signal,
        User $user
    ): void {
        $oldStatus = $signal->status;

        $signal->reject();

        $this->historyService->record(
            signal: $signal,
            user: $user,
            event: 'rejected',
            oldStatus: $oldStatus,
            newStatus: Signal::STATUS_REJECTED,
            description: 'Signal rejected.',
        );
    }

    /**
     * Publish Signal.
     */
    public function publish(
        Signal $signal,
        User $user
    ): void {
        $oldStatus = $signal->status;

        $signal->publish();

        $this->historyService->record(
            signal: $signal,
            user: $user,
            event: 'published',
            oldStatus: $oldStatus,
            newStatus: Signal::STATUS_PUBLISHED,
            description: 'Signal published.',
        );
    }

    /**
     * Start Signal.
     */
    public function start(
        Signal $signal,
        User $user
    ): void {
        $oldStatus = $signal->status;

        $signal->start();

        $this->historyService->record(
            signal: $signal,
            user: $user,
            event: 'started',
            oldStatus: $oldStatus,
            newStatus: Signal::STATUS_RUNNING,
            description: 'Signal started.',
        );
    }

    /**
     * Record TP1.
     */
    public function tp1(
        Signal $signal,
        User $user
    ): void {
        $this->ensureRunning($signal);

        if ($signal->tp1_hit_at !== null) {
            throw ValidationException::withMessages([
                'tp1' => 'TP1 has already been recorded.',
            ]);
        }

        $signal->markTp1();

        $this->historyService->record(
            signal: $signal,
            user: $user,
            event: 'tp1',
            oldStatus: $signal->status,
            newStatus: $signal->status,
            description: 'Take Profit 1 reached.',
        );
    }

    /**
     * Record TP2.
     */
    public function tp2(
        Signal $signal,
        User $user
    ): void {
        $this->ensureRunning($signal);

        if ($signal->tp1_hit_at === null) {
            throw ValidationException::withMessages([
                'tp2' => 'TP1 must be recorded before TP2.',
            ]);
        }

        if ($signal->tp2_hit_at !== null) {
            throw ValidationException::withMessages([
                'tp2' => 'TP2 has already been recorded.',
            ]);
        }

        $signal->markTp2();

        $this->historyService->record(
            signal: $signal,
            user: $user,
            event: 'tp2',
            oldStatus: $signal->status,
            newStatus: $signal->status,
            description: 'Take Profit 2 reached.',
        );
    }

    /**
     * Record TP3.
     */
    public function tp3(
        Signal $signal,
        User $user
    ): void {
        $this->ensureRunning($signal);

        if ($signal->tp2_hit_at === null) {
            throw ValidationException::withMessages([
                'tp3' => 'TP2 must be recorded before TP3.',
            ]);
        }

        if ($signal->tp3_hit_at !== null) {
            throw ValidationException::withMessages([
                'tp3' => 'TP3 has already been recorded.',
            ]);
        }

        $signal->markTp3();

        $this->historyService->record(
            signal: $signal,
            user: $user,
            event: 'tp3',
            oldStatus: $signal->status,
            newStatus: $signal->status,
            description: 'Take Profit 3 reached.',
        );
    }

    /**
     * Close Signal.
     */
    public function close(
        Signal $signal,
        User $user,
        string $result,
        int $pips
    ): void {
        $this->ensureRunning($signal);

        if (!in_array($result, [
            'win',
            'loss',
            'breakeven',
        ], true)) {
            throw ValidationException::withMessages([
                'result' => 'Invalid signal result.',
            ]);
        }

        if ($signal->result !== null) {
            throw ValidationException::withMessages([
                'result' => 'Signal has already been closed.',
            ]);
        }

        $oldStatus = $signal->status;

        $signal->close($result, $pips);

        $this->historyService->record(
            signal: $signal,
            user: $user,
            event: 'closed',
            oldStatus: $oldStatus,
            newStatus: Signal::STATUS_CLOSED,
            description: "Signal closed ({$result}, {$pips} pips).",
        );
    }

    /**
     * Archive Signal.
     */
    public function archive(
        Signal $signal,
        User $user
    ): void {
        $oldStatus = $signal->status;

        $signal->expire();

        $this->historyService->record(
            signal: $signal,
            user: $user,
            event: 'archived',
            oldStatus: $oldStatus,
            newStatus: Signal::STATUS_EXPIRED,
            description: 'Signal archived.',
        );
    }

    /**
     * Run AI historical confirmation.
     *
     * AI only analyzes historical evidence.
     * It does not approve, reject, publish, or
     * otherwise control the signal workflow.
     */
    public function runAiConfirmation(
        Signal $signal,
        User $user
    ): array {
        return $this->aiConfirmationService->analyze($signal);
    }

    /**
     * Ensure the signal is currently running.
     */
    protected function ensureRunning(
        Signal $signal
    ): void {
        if (!$signal->isRunning()) {
            throw ValidationException::withMessages([
                'signal' =>
                    'This action can only be performed while the signal is running.',
            ]);
        }
    }
}