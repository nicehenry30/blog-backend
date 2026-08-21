<?php

namespace Tests\Feature;

use App\Models\Signal;
use App\Models\SignalHistory;
use App\Models\Symbol;
use App\Models\User;
use App\Services\SignalWorkflowService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class SignalWorkflowTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;

    protected Symbol $symbol;

    protected Signal $signal;

    protected function setUp(): void
    {
        parent::setUp();

        $this->user = User::factory()->create();

        $this->symbol = Symbol::create([
            'symbol' => 'XAUUSD',
            'name' => 'Gold',
            'asset_type' => 'Metal',
        ]);

        $this->signal = Signal::create([
            'symbol_id' => $this->symbol->id,

            'direction' => 'BUY',

            'entry_price' => 4528.50000,

            'stop_loss' => 4521.51000,

            'take_profit' => 4531.72000,

            'take_profit_2' => 4535.61000,

            'take_profit_3' => 4540.00000,

            'timeframe' => 'M5',

            'signal_quality' => 88,

            'overall_confidence' => 81,

            'strategy' => 'Trend continuation',

            'risk_reward' => 2.0,

            'analysis' => 'Trend continuation setup.',

            'confluences' => [
                'Market Structure',
            ],

            'status' => Signal::STATUS_DRAFT,

            'visibility' => 'free',

            'auto_executable' => false,

            'created_by' => $this->user->id,
        ]);
    }

    /** 
     * Test the complete signal workflow.
     */
    public function test_complete_workflow_creates_history(): void
    {
        $service = app(SignalWorkflowService::class);

        /*
        |--------------------------------------------------------------------------
        | Approve
        |--------------------------------------------------------------------------
        */

        $service->approve(
            $this->signal,
            $this->user
        );

        $this->signal->refresh();

        $this->assertSame(
            Signal::STATUS_APPROVED,
            $this->signal->status
        );

        /*
        |--------------------------------------------------------------------------
        | Publish
        |--------------------------------------------------------------------------
        */

        $service->publish(
            $this->signal,
            $this->user
        );

        $this->signal->refresh();

        $this->assertSame(
            Signal::STATUS_PUBLISHED,
            $this->signal->status
        );

        /*
        |--------------------------------------------------------------------------
        | Start
        |--------------------------------------------------------------------------
        */

        $service->start(
            $this->signal,
            $this->user
        );

        $this->signal->refresh();

        $this->assertSame(
            Signal::STATUS_RUNNING,
            $this->signal->status
        );

        /*
        |--------------------------------------------------------------------------
        | TP1
        |--------------------------------------------------------------------------
        */

        $service->tp1(
            $this->signal,
            $this->user
        );

        $this->signal->refresh();

        $this->assertNotNull(
            $this->signal->tp1_hit_at
        );

        /*
        |--------------------------------------------------------------------------
        | TP2
        |--------------------------------------------------------------------------
        */

        $service->tp2(
            $this->signal,
            $this->user
        );

        $this->signal->refresh();

        $this->assertNotNull(
            $this->signal->tp2_hit_at
        );

        /*
        |--------------------------------------------------------------------------
        | TP3
        |--------------------------------------------------------------------------
        */

        $service->tp3(
            $this->signal,
            $this->user
        );

        $this->signal->refresh();

        $this->assertNotNull(
            $this->signal->tp3_hit_at
        );

        /*
        |--------------------------------------------------------------------------
        | Close
        |--------------------------------------------------------------------------
        */

        $service->close(
            $this->signal,
            $this->user,
            'win',
            115
        );

        $this->signal->refresh();

        $this->assertSame(
            Signal::STATUS_CLOSED,
            $this->signal->status
        );

        $this->assertSame(
            'win',
            $this->signal->result
        );

        $this->assertSame(
            115,
            $this->signal->pips
        );

        $this->assertNotNull(
            $this->signal->closed_at
        );

        /*
        |--------------------------------------------------------------------------
        | Verify History
        |--------------------------------------------------------------------------
        */

        $this->assertDatabaseHas(
            'signal_histories',
            [
                'signal_id' => $this->signal->id,
                'event' => 'approved',
            ]
        );

        $this->assertDatabaseHas(
            'signal_histories',
            [
                'signal_id' => $this->signal->id,
                'event' => 'published',
            ]
        );

        $this->assertDatabaseHas(
            'signal_histories',
            [
                'signal_id' => $this->signal->id,
                'event' => 'started',
            ]
        );

        $this->assertDatabaseHas(
            'signal_histories',
            [
                'signal_id' => $this->signal->id,
                'event' => 'tp1',
            ]
        );

        $this->assertDatabaseHas(
            'signal_histories',
            [
                'signal_id' => $this->signal->id,
                'event' => 'tp2',
            ]
        );

        $this->assertDatabaseHas(
            'signal_histories',
            [
                'signal_id' => $this->signal->id,
                'event' => 'tp3',
            ]
        );

        $this->assertDatabaseHas(
            'signal_histories',
            [
                'signal_id' => $this->signal->id,
                'event' => 'closed',
            ]
        );
    }

    /**
     * TP cannot be recorded after the signal is closed.
     */
    public function test_tp_cannot_be_recorded_after_signal_is_closed(): void
    {
        $service = app(SignalWorkflowService::class);

        /*
        |--------------------------------------------------------------------------
        | Move signal to Running
        |--------------------------------------------------------------------------
        */

        $service->approve(
            $this->signal,
            $this->user
        );

        $service->publish(
            $this->signal,
            $this->user
        );

        $service->start(
            $this->signal,
            $this->user
        );

        /*
        |--------------------------------------------------------------------------
        | Close signal
        |--------------------------------------------------------------------------
        */

        $service->close(
            $this->signal,
            $this->user,
            'win',
            100
        );

        $this->signal->refresh();

        $this->assertSame(
            Signal::STATUS_CLOSED,
            $this->signal->status
        );

        /*
        |--------------------------------------------------------------------------
        | Attempt TP1 after close
        |--------------------------------------------------------------------------
        */

        $this->expectException(\Throwable::class);

        $service->tp1(
            $this->signal,
            $this->user
        );
    }
}