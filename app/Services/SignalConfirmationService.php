<?php

namespace App\Services;

use App\Models\Signal;

class SignalConfirmationService
{
    public function __construct(
        protected SignalMinimumRequirementService $minimumRequirementService,
        protected SignalAiConfirmationService $aiConfirmationService,
    ) {
    }

    /**
     * Run the complete confirmation process.
     *
     * The AI does not approve or reject the signal.
     * It only provides an evidence-based assessment.
     */
    public function analyze(Signal $signal): array
    {
        /*
        |--------------------------------------------------------------------------
        | Step 1: Minimum Requirements
        |--------------------------------------------------------------------------
        */

        $requirements = $this->minimumRequirementService
            ->check($signal);

        if (!$requirements['eligible']) {
            return [
                'eligible' => false,

                'status' => 'not_eligible',

                'requirements' => $requirements,

                'ai' => [
                    'score' => null,
                    'review' => 'NOT ANALYZED',
                    'comment' =>
                        'The signal does not meet the minimum '
                        . 'requirements for historical AI analysis.',
                    'historical' => null,
                ],
            ];
        }

        /*
        |--------------------------------------------------------------------------
        | Step 2: Historical AI Analysis
        |--------------------------------------------------------------------------
        */

        $ai = $this->aiConfirmationService
            ->analyze($signal);

        return [
            'eligible' => true,

            'status' => 'analyzed',

            'requirements' => $requirements,

            'ai' => $ai,
        ];
    }
}