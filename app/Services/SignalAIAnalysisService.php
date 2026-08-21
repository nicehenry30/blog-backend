<?php

namespace App\Services;

use App\Models\Signal;

class SignalAIAnalysisService
{
    /**
     * Minimum signal quality required before AI analysis.
     */
    protected float $minimumSignalQuality = 60;

    /**
     * Minimum overall confidence required before AI analysis.
     */
    protected float $minimumOverallConfidence = 60;

    public function __construct(
        protected HistoricalSignalAnalysisService $historicalAnalysisService,
    ) {
    }

    /**
     * Analyze a signal using historical trading evidence.
     *
     * AI does not approve or reject the signal.
     * It only provides an evidence-based score and review.
     */
    public function analyze(Signal $signal): array
    {
        /*
        |--------------------------------------------------------------------------
        | Minimum Signal Threshold
        |--------------------------------------------------------------------------
        */

        if (!$this->meetsMinimumThreshold($signal)) {
            return [
                'ai_score' => null,
                'ai_review' => 'below_threshold',
                'ai_comment' => $this->buildThresholdComment($signal),
                'historical_analysis' => null,
            ];
        }

        /*
        |--------------------------------------------------------------------------
        | Historical Analysis
        |--------------------------------------------------------------------------
        */

        $historical = $this->historicalAnalysisService->analyze($signal);

        /*
        |--------------------------------------------------------------------------
        | Insufficient Historical Evidence
        |--------------------------------------------------------------------------
        */

        if (!$historical['sufficient_evidence']) {
            return [
                'ai_score' => null,
                'ai_review' => 'insufficient_data',
                'ai_comment' => $this->buildInsufficientEvidenceComment(
                    $historical
                ),
                'historical_analysis' => $historical,
            ];
        }

        /*
        |--------------------------------------------------------------------------
        | Calculate Evidence-Based AI Score
        |--------------------------------------------------------------------------
        */

        $score = $this->calculateScore($historical);

        /*
        |--------------------------------------------------------------------------
        | Determine AI Review
        |--------------------------------------------------------------------------
        */

        $review = $this->determineReview($score);

        /*
        |--------------------------------------------------------------------------
        | Generate Explanation
        |--------------------------------------------------------------------------
        */

        $comment = $this->buildComment(
            signal: $signal,
            historical: $historical,
            score: $score,
            review: $review,
        );

        return [
            'ai_score' => $score,
            'ai_review' => $review,
            'ai_comment' => $comment,
            'historical_analysis' => $historical,
        ];
    }

    /**
     * Determine whether the signal meets the minimum
     * requirements for AI analysis.
     */
    protected function meetsMinimumThreshold(
        Signal $signal
    ): bool {
        return (float) $signal->signal_quality
            >= $this->minimumSignalQuality
            &&
            (float) $signal->overall_confidence
            >= $this->minimumOverallConfidence;
    }

    /**
     * Calculate an evidence-based score from 0-100.
     */
    protected function calculateScore(array $historical): int
    {
        $winRate = (float) $historical['win_rate'];

        $tp1Rate = (float) $historical['tp1_success_rate'];

        $tp2Rate = (float) $historical['tp2_success_rate'];

        $tp3Rate = (float) $historical['tp3_success_rate'];

        $averagePips = (float) $historical['average_pips'];

        /*
        |--------------------------------------------------------------------------
        | Win Rate
        |--------------------------------------------------------------------------
        */

        $winRateScore = min($winRate, 100) * 0.50;

        /*
        |--------------------------------------------------------------------------
        | Take Profit Performance
        |--------------------------------------------------------------------------
        */

        $tp1Score = min($tp1Rate, 100) * 0.15;

        $tp2Score = min($tp2Rate, 100) * 0.10;

        $tp3Score = min($tp3Rate, 100) * 0.10;

        /*
        |--------------------------------------------------------------------------
        | Average Pips
        |--------------------------------------------------------------------------
        */

        $normalizedPips = max(
            0,
            min($averagePips, 50)
        );

        $pipScore = ($normalizedPips / 50) * 15;

        /*
        |--------------------------------------------------------------------------
        | Final Score
        |--------------------------------------------------------------------------
        */

        $score = $winRateScore
            + $tp1Score
            + $tp2Score
            + $tp3Score
            + $pipScore;

        return (int) round(
            max(0, min($score, 100))
        );
    }

    /**
     * Determine the AI review.
     */
    protected function determineReview(int $score): string
    {
        if ($score >= 75) {
            return 'strong';
        }

        if ($score >= 60) {
            return 'positive';
        }

        if ($score >= 45) {
            return 'neutral';
        }

        return 'weak';
    }

    /**
     * Explain why the signal did not meet
     * the minimum AI-analysis threshold.
     */
    protected function buildThresholdComment(
        Signal $signal
    ): string {
        return sprintf(
            'AI analysis was not performed because the signal did not meet the minimum analysis threshold. Signal Quality: %.2f/100. Overall Confidence: %.2f/100. Minimum required values are 60/100 for both metrics.',
            (float) $signal->signal_quality,
            (float) $signal->overall_confidence,
        );
    }

    /**
     * Explain insufficient historical evidence.
     */
    protected function buildInsufficientEvidenceComment(
        array $historical
    ): string {
        $sampleSize = $historical['sample_size'];

        return sprintf(
            'AI review is inconclusive because only %d comparable completed historical signal(s) are available. At least 20 comparable signals are required before meaningful historical evidence can be used.',
            $sampleSize
        );
    }

    /**
     * Build the evidence-based AI comment.
     */
    protected function buildComment(
        Signal $signal,
        array $historical,
        int $score,
        string $review
    ): string {
        $sampleSize = $historical['sample_size'];

        $winRate = $historical['win_rate'];

        $averagePips = $historical['average_pips'];

        $tp1Rate = $historical['tp1_success_rate'];

        $tp2Rate = $historical['tp2_success_rate'];

        $tp3Rate = $historical['tp3_success_rate'];

        $direction = strtoupper($signal->direction);

        $symbol = $signal->symbol?->symbol
            ?? 'the selected symbol';

        $reviewText = match ($review) {
            'strong' =>
                'Historical evidence strongly supports this setup.',

            'positive' =>
                'Historical evidence provides a positive confirmation for this setup.',

            'neutral' =>
                'Historical evidence provides mixed or moderate confirmation for this setup.',

            'weak' =>
                'Historical evidence is weak for this setup and deserves additional review.',

            default =>
                'Historical evidence could not be interpreted.',
        };

        return sprintf(
            'AI review for %s %s: %s Based on %d comparable completed historical signals, the historical win rate was %.2f%% with an average result of %.2f pips. TP1 was reached in %.2f%% of comparable trades, TP2 in %.2f%%, and TP3 in %.2f%%. AI score: %d/100. This review is based on historical trading evidence and supports human decision-making; it does not automatically approve or reject the signal.',
            $symbol,
            $direction,
            $reviewText,
            $sampleSize,
            $winRate,
            $averagePips,
            $tp1Rate,
            $tp2Rate,
            $tp3Rate,
            $score,
        );
    }
}