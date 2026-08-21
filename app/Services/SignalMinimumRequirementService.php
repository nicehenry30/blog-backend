<?php

namespace App\Services;

use App\Models\Signal;

class SignalMinimumRequirementService
{
    /**
     * Minimum signal quality required before
     * historical AI analysis can run.
     */
    protected float $minimumSignalQuality = 60;

    /**
     * Minimum overall confidence required.
     */
    protected float $minimumOverallConfidence = 60;

    /**
     * Check whether a signal meets the minimum
     * requirements for AI analysis.
     */
    public function check(Signal $signal): array
    {
        $errors = [];

        if ($signal->signal_quality < $this->minimumSignalQuality) {
            $errors[] = sprintf(
                'Signal quality must be at least %s.',
                $this->minimumSignalQuality
            );
        }

        if (
            $signal->overall_confidence <
            $this->minimumOverallConfidence
        ) {
            $errors[] = sprintf(
                'Overall confidence must be at least %s.',
                $this->minimumOverallConfidence
            );
        }

        if (!$signal->symbol_id) {
            $errors[] = 'Trading symbol is required.';
        }

        if (!$signal->direction) {
            $errors[] = 'Trading direction is required.';
        }

        if (!$signal->timeframe) {
            $errors[] = 'Timeframe is required.';
        }

        if (!$signal->strategy) {
            $errors[] = 'Trading strategy is required.';
        }

        if ($signal->entry_price === null) {
            $errors[] = 'Entry price is required.';
        }

        if ($signal->stop_loss === null) {
            $errors[] = 'Stop loss is required.';
        }

        if ($signal->take_profit === null) {
            $errors[] = 'Take profit is required.';
        }

        return [
            'eligible' => empty($errors),
            'errors' => $errors,
            'minimum_signal_quality' =>
                $this->minimumSignalQuality,
            'minimum_overall_confidence' =>
                $this->minimumOverallConfidence,
        ];
    }
}