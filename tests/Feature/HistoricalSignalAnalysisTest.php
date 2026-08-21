<?php

namespace Tests\Feature;

use App\Models\Signal;
use App\Models\Symbol;
use App\Models\User;
use App\Services\HistoricalSignalAnalysisService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class HistoricalSignalAnalysisTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;

    protected Symbol $symbol;

    protected function setUp(): void
    {
        parent::setUp();

        $this->user = User::factory()->create();

        $this->symbol = Symbol::create([
            'symbol' => 'XAUUSD',
            'name' => 'Gold',
            'asset_type' => 'Metal',
            'broker_symbol' => 'XAUUSD',
            'digits' => 2,
            'active' => true,
        ]);
    }

    protected function createSignal(
        string $status = Signal::STATUS_CLOSED,
        ?string $result = 'win',
        ?int $pips = 50,
        bool $tp1 = true,
        bool $tp2 = true,
        bool $tp3 = false,
        string $direction = 'BUY',
        string $timeframe = 'M5',
        string $strategy = 'Trend continuation',
    ): Signal {
        return Signal::create([
            'symbol_id' => $this->symbol->id,

            'direction' => $direction,

            'entry_price' => 3400.00000,

            'stop_loss' => 3390.00000,

            'take_profit' => 3420.00000,

            'take_profit_2' => 3430.00000,

            'take_profit_3' => 3440.00000,

            'timeframe' => $timeframe,

            'signal_quality' => 85,

            'overall_confidence' => 80,

            'strategy' => $strategy,

            'risk_reward' => 2.00,

            'analysis' => 'Test historical signal.',

            'confluences' => ['Market Structure'],

            'status' => $status,

            'result' => $result,

            'pips' => $pips,

            'created_by' => $this->user->id,

            'approved_by' => $this->user->id,

            'approved_at' => now(),

            'published_at' => now(),

            'closed_at' => $status === Signal::STATUS_CLOSED
                ? now()
                : null,

            'tp1_hit_at' => $tp1 ? now() : null,

            'tp2_hit_at' => $tp2 ? now() : null,

            'tp3_hit_at' => $tp3 ? now() : null,
        ]);
    }

    public function test_running_signal_is_not_used_as_historical_data(): void
    {
        $this->createSignal(
            status: Signal::STATUS_RUNNING,
            result: null,
            pips: null,
        );

        $currentSignal = $this->createSignal(
            status: Signal::STATUS_RUNNING,
            result: null,
            pips: null,
        );

        $analysis = app(HistoricalSignalAnalysisService::class)
            ->analyze($currentSignal);

        $this->assertSame(0, $analysis['sample_size']);
    }

    public function test_published_signal_is_not_used_as_historical_data(): void
    {
        $this->createSignal(
            status: Signal::STATUS_PUBLISHED,
            result: null,
            pips: null,
        );

        $currentSignal = $this->createSignal(
            status: Signal::STATUS_RUNNING,
            result: null,
            pips: null,
        );

        $analysis = app(HistoricalSignalAnalysisService::class)
            ->analyze($currentSignal);

        $this->assertSame(0, $analysis['sample_size']);
    }

    public function test_closed_signal_is_used_as_historical_data(): void
    {
        $this->createSignal();

        $currentSignal = $this->createSignal(
            status: Signal::STATUS_RUNNING,
            result: null,
            pips: null,
        );

        $analysis = app(HistoricalSignalAnalysisService::class)
            ->analyze($currentSignal);

        $this->assertSame(1, $analysis['sample_size']);

        $this->assertSame(1, $analysis['wins']);

        $this->assertSame(50.0, $analysis['average_pips']);
    }

    public function test_tp_success_rates_use_manual_tp_timestamps(): void
    {
        $this->createSignal(
            tp1: true,
            tp2: true,
            tp3: true,
        );

        $currentSignal = $this->createSignal(
            status: Signal::STATUS_RUNNING,
            result: null,
            pips: null,
        );

        $analysis = app(HistoricalSignalAnalysisService::class)
            ->analyze($currentSignal);

        $this->assertSame(100.0, $analysis['tp1_success_rate']);

        $this->assertSame(100.0, $analysis['tp2_success_rate']);

        $this->assertSame(100.0, $analysis['tp3_success_rate']);
    }

    public function test_tp_rates_distinguish_between_hit_and_not_hit(): void
    {
        $this->createSignal(
            tp1: true,
            tp2: true,
            tp3: false,
        );

        $this->createSignal(
            tp1: true,
            tp2: false,
            tp3: false,
        );

        $currentSignal = $this->createSignal(
            status: Signal::STATUS_RUNNING,
            result: null,
            pips: null,
        );

        $analysis = app(HistoricalSignalAnalysisService::class)
            ->analyze($currentSignal);

        $this->assertSame(100.0, $analysis['tp1_success_rate']);

        $this->assertSame(50.0, $analysis['tp2_success_rate']);

        $this->assertSame(0.0, $analysis['tp3_success_rate']);
    }

    public function test_different_symbol_is_not_comparable(): void
    {
        $otherSymbol = Symbol::create([
            'symbol' => 'EURUSD',
            'name' => 'Euro US Dollar',
            'asset_type' => 'Forex',
            'broker_symbol' => 'EURUSD',
            'digits' => 5,
            'active' => true,
        ]);

        $this->createSignal();

        $currentSignal = $this->createSignal(
            status: Signal::STATUS_RUNNING,
            result: null,
            pips: null,
        );

        $currentSignal->update([
            'symbol_id' => $otherSymbol->id,
        ]);

        $analysis = app(HistoricalSignalAnalysisService::class)
            ->analyze($currentSignal);

        $this->assertSame(0, $analysis['sample_size']);
    }

    public function test_different_direction_is_not_comparable(): void
    {
        $this->createSignal(
            direction: 'BUY'
        );

        $currentSignal = $this->createSignal(
            status: Signal::STATUS_RUNNING,
            result: null,
            pips: null,
            direction: 'SELL',
        );

        $analysis = app(HistoricalSignalAnalysisService::class)
            ->analyze($currentSignal);

        $this->assertSame(0, $analysis['sample_size']);
    }

    public function test_different_timeframe_is_not_comparable(): void
    {
        $this->createSignal(
            timeframe: 'M5'
        );

        $currentSignal = $this->createSignal(
            status: Signal::STATUS_RUNNING,
            result: null,
            pips: null,
            timeframe: 'H1',
        );

        $analysis = app(HistoricalSignalAnalysisService::class)
            ->analyze($currentSignal);

        $this->assertSame(0, $analysis['sample_size']);
    }

    public function test_different_strategy_is_not_comparable(): void
    {
        $this->createSignal(
            strategy: 'Trend continuation'
        );

        $currentSignal = $this->createSignal(
            status: Signal::STATUS_RUNNING,
            result: null,
            pips: null,
            strategy: 'Reversal',
        );

        $analysis = app(HistoricalSignalAnalysisService::class)
            ->analyze($currentSignal);

        $this->assertSame(0, $analysis['sample_size']);
    }

    public function test_nineteen_comparable_signals_produce_insufficient_evidence(): void
    {
        for ($i = 0; $i < 19; $i++) {
            $this->createSignal();
        }

        $currentSignal = $this->createSignal(
            status: Signal::STATUS_RUNNING,
            result: null,
            pips: null,
        );

        $analysis = app(HistoricalSignalAnalysisService::class)
            ->analyze($currentSignal);

        $this->assertSame(19, $analysis['sample_size']);

        $this->assertFalse(
            $analysis['sufficient_evidence']
        );

        $this->assertNull(
            $analysis['ai_score']
        );

        $this->assertSame(
            'insufficient',
            $analysis['evidence_level']
        );
    }

    public function test_twenty_comparable_signals_produce_sufficient_evidence(): void
    {
        for ($i = 0; $i < 20; $i++) {
            $this->createSignal();
        }

        $currentSignal = $this->createSignal(
            status: Signal::STATUS_RUNNING,
            result: null,
            pips: null,
        );

        $analysis = app(HistoricalSignalAnalysisService::class)
            ->analyze($currentSignal);

        $this->assertSame(20, $analysis['sample_size']);

        $this->assertTrue(
            $analysis['sufficient_evidence']
        );

        $this->assertNotNull(
            $analysis['ai_score']
        );

        $this->assertSame(
            'limited',
            $analysis['evidence_level']
        );
    }
}