<?php

namespace App\Services;

use App\Models\Signal;

class HistoricalSignalAnalysisService
{
    /**
     * Minimum number of comparable historical signals
     * required before producing an AI score.
     */
    protected const MINIMUM_SAMPLE_SIZE = 20;

    /**
     * Analyze historical signals comparable to the current signal.
     */
    public function analyze(Signal $currentSignal): array
    {
        $historicalSignals = Signal::query()
            ->where('id', '!=', $currentSignal->id)
            ->where('status', Signal::STATUS_CLOSED)
            ->where('symbol_id', $currentSignal->symbol_id)
            ->where('direction', $currentSignal->direction)
            ->where('timeframe', $currentSignal->timeframe)
            ->where('strategy', $currentSignal->strategy)
            ->get();

        $sampleSize = $historicalSignals->count();

        $wins = $historicalSignals
            ->where('result', 'win')
            ->count();

        $losses = $historicalSignals
            ->where('result', 'loss')
            ->count();

        $breakevens = $historicalSignals
            ->where('result', 'breakeven')
            ->count();

        $averagePips = $sampleSize > 0
            ? (float) $historicalSignals->avg('pips')
            : 0.0;

        $tp1SuccessRate = $this->calculateTpSuccessRate(
            $historicalSignals,
            'tp1_hit_at'
        );

        $tp2SuccessRate = $this->calculateTpSuccessRate(
            $historicalSignals,
            'tp2_hit_at'
        );

        $tp3SuccessRate = $this->calculateTpSuccessRate(
            $historicalSignals,
            'tp3_hit_at'
        );

        $sufficientEvidence = $sampleSize >= self::MINIMUM_SAMPLE_SIZE;

        $aiScore = $sufficientEvidence
            ? $this->calculateAiScore(
                sampleSize: $sampleSize,
                wins: $wins,
                losses: $losses,
                tp1SuccessRate: $tp1SuccessRate,
                tp2SuccessRate: $tp2SuccessRate,
                tp3SuccessRate: $tp3SuccessRate,
            )
            : null;

        return [
            'sample_size' => $sampleSize,

            'wins' => $wins,

            'losses' => $losses,

            'breakevens' => $breakevens,

            'average_pips' => $averagePips,

            'tp1_success_rate' => $tp1SuccessRate,

            'tp2_success_rate' => $tp2SuccessRate,

            'tp3_success_rate' => $tp3SuccessRate,

            'sufficient_evidence' => $sufficientEvidence,

            'ai_score' => $aiScore,

            'evidence_level' => $this->determineEvidenceLevel(
                $sampleSize
            ),
        ];
    }

    /**
     * Calculate the percentage of historical signals
     * that reached a particular TP.
     */
    protected function calculateTpSuccessRate(
        $signals,
        string $column
    ): float {
        $sampleSize = $signals->count();

        if ($sampleSize === 0) {
            return 0.0;
        }

        $hits = $signals
            ->filter(fn (Signal $signal) => $signal->{$column} !== null)
            ->count();

        return round(
            ($hits / $sampleSize) * 100,
            2
        );
    }

    /**
     * Calculate a conservative historical score.
     */
    protected function calculateAiScore(
        int $sampleSize,
        int $wins,
        int $losses,
        float $tp1SuccessRate,
        float $tp2SuccessRate,
        float $tp3SuccessRate,
    ): float {
        $winRate = $sampleSize > 0
            ? ($wins / $sampleSize) * 100
            : 0;

        /*
         * Historical score weighting:
         *
         * Win rate       = 50%
         * TP1 success    = 20%
         * TP2 success    = 15%
         * TP3 success    = 15%
         */
        $score =
            ($winRate * 0.50) +
            ($tp1SuccessRate * 0.20) +
            ($tp2SuccessRate * 0.15) +
            ($tp3SuccessRate * 0.15);

        return round(
            max(0, min(100, $score)),
            2
        );
    }

    /**
     * Determine the strength of historical evidence.
     */
    protected function determineEvidenceLevel(
        int $sampleSize
    ): string {
        if ($sampleSize < 20) {
            return 'insufficient';
        }

        if ($sampleSize < 50) {
            return 'limited';
        }

        if ($sampleSize < 100) {
            return 'moderate';
        }

        return 'strong';
    }
}