<?php

namespace App\Services;

use App\Models\Signal;

class SignalAiConfirmationService
{
    public function __construct(
        protected HistoricalSignalAnalysisService $historicalAnalysisService,
    ) {
    }

    /**
     * Generate an AI-style confirmation based strictly
     * on historical trading evidence.
     *
     * The AI does not approve or reject the signal.
     * It only evaluates the historical evidence.
     */
    public function analyze(Signal $signal): array
    {
        $historical = $this->historicalAnalysisService
            ->analyze($signal);

        /*
        |--------------------------------------------------------------------------
        | Insufficient Evidence
        |--------------------------------------------------------------------------
        */

        if (!$historical['sufficient_evidence']) {
            return [
                'score' => null,
                'review' => 'INSUFFICIENT DATA',
                'comment' => $this->buildInsufficientComment(
                    $historical
                ),
                'historical' => $historical,
            ];
        }

        /*
        |--------------------------------------------------------------------------
        | Calculate Historical Score
        |--------------------------------------------------------------------------
        |
        | The score is based on actual historical outcomes.
        |
        */

        $winRateScore = $historical['win_rate'];

        $tp1Score = $historical['tp1_success_rate'];

        $tp2Score = $historical['tp2_success_rate'];

        $averagePipsScore = $this->averagePipsScore(
            $historical['average_pips']
        );

        /*
        |--------------------------------------------------------------------------
        | Weighted Score
        |--------------------------------------------------------------------------
        */

        $score = (
            ($winRateScore * 0.50) +
            ($tp1Score * 0.20) +
            ($tp2Score * 0.15) +
            ($averagePipsScore * 0.15)
        );

        $score = (int) round(
            max(0, min(100, $score))
        );

        /*
        |--------------------------------------------------------------------------
        | Review
        |--------------------------------------------------------------------------
        */

        $review = $this->getReview($score);

        /*
        |--------------------------------------------------------------------------
        | Comment
        |--------------------------------------------------------------------------
        */

        $comment = $this->buildComment(
            $historical,
            $score,
            $review
        );

        return [
            'score' => $score,
            'review' => $review,
            'comment' => $comment,
            'historical' => $historical,
        ];
    }

    /**
     * Convert average historical pips
     * into a 0-100 component score.
     */
    protected function averagePipsScore(
        float $averagePips
    ): float {

        if ($averagePips <= 0) {
            return 0;
        }

        /*
        |--------------------------------------------------------------------------
        | 100 points = +100 pips or more.
        |--------------------------------------------------------------------------
        */

        return min(
            100,
            ($averagePips / 100) * 100
        );
    }

    /**
     * Determine the AI review category.
     */
    protected function getReview(
        int $score
    ): string {

        if ($score >= 80) {
            return 'STRONG';
        }

        if ($score >= 65) {
            return 'GOOD';
        }

        if ($score >= 50) {
            return 'CAUTION';
        }

        return 'WEAK';
    }

    /**
     * Build comment when historical evidence
     * is insufficient.
     */
    protected function buildInsufficientComment(
        array $historical
    ): string {

        $sampleSize = $historical['sample_size'];

        return sprintf(
            'Historical evidence is insufficient. '
            . '%d comparable completed signals were found. '
            . 'At least 20 comparable signals are required '
            . 'before a meaningful AI score can be calculated.',
            $sampleSize
        );
    }

    /**
     * Build evidence-based AI comment.
     */
    protected function buildComment(
        array $historical,
        int $score,
        string $review
    ): string {

        return sprintf(
            'Historical analysis rates this signal as %s. '
            . 'Comparable signals produced a %.2f%% win rate '
            . 'from %d completed trades, with an average result '
            . 'of %.2f pips. TP1 success was %.2f%% and TP2 '
            . 'success was %.2f%%. Historical evidence level: %s.',
            $review,
            $historical['win_rate'],
            $historical['sample_size'],
            $historical['average_pips'],
            $historical['tp1_success_rate'],
            $historical['tp2_success_rate'],
            $historical['evidence_level'],
        );
    }
}