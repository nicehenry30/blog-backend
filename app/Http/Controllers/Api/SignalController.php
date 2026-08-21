<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreSignalRequest;
use App\Http\Requests\UpdateSignalRequest;
use App\Http\Resources\SignalResource;
use App\Models\Signal;
use App\Services\SignalHistoryService;
use App\Services\SignalWorkflowService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SignalController extends Controller
{
    public function __construct(
        protected SignalWorkflowService $workflowService,
        protected SignalHistoryService $historyService,
    ) {
    }

    /**
     * Display published and running signals.
     */
    public function index()
    {
        $signals = Signal::with([
            'symbol',
            'creator',
            'approver',
            'histories',
        ])
            ->whereIn('status', [
                Signal::STATUS_PUBLISHED,
                Signal::STATUS_RUNNING,
            ])
            ->latest()
            ->get();

        return SignalResource::collection($signals);
    }

    /**
     * Store a new signal.
     *
     * The trading team creates the signal.
     * AI analysis is handled separately through the
     * SignalWorkflowService.
     */
    public function store(
        StoreSignalRequest $request
    ): SignalResource {

        $data = $request->validated();

        $data['created_by'] = auth()->id();

        $signal = Signal::create($data);

        $this->historyService->record(
            signal: $signal,
            user: auth()->user(),
            event: 'created',
            oldStatus: null,
            newStatus: $signal->status,
            description: 'Signal created.',
        );

        return new SignalResource(
            $signal->load([
                'symbol',
                'creator',
                'approver',
                'histories',
            ])
        );
    }

    /**
     * Display a signal.
     */
    public function show(
        Signal $signal
    ): SignalResource {

        return new SignalResource(
            $signal->load([
                'symbol',
                'creator',
                'approver',
                'histories',
            ])
        );
    }

    /**
     * Update a signal.
     */
    public function update(
        UpdateSignalRequest $request,
        Signal $signal
    ): SignalResource {

        $signal->update(
            $request->validated()
        );

        return new SignalResource(
            $signal->fresh()->load([
                'symbol',
                'creator',
                'approver',
                'histories',
            ])
        );
    }

    /**
     * Delete a signal.
     */
    public function destroy(
        Signal $signal
    ): JsonResponse {

        $signal->delete();

        return response()->json([
            'message' => 'Signal deleted successfully.',
        ]);
    }

    /**
     * Approve signal.
     *
     * This is an administrative/trading-team decision.
     * AI does not approve the signal.
     */
    public function approve(Signal $signal
    ): SignalResource {

        $this->workflowService->approve(
            $signal,
            auth()->user(),
        );

        return new SignalResource(
            $signal->fresh()->load([
                'symbol',
                'creator',
                'approver',
                'histories',
            ])
        );
    }

    /**
     * Reject signal.
     *
     * This is an administrative/trading-team decision.
     * AI does not reject the signal.
     */
    public function reject(
        Signal $signal
    ): SignalResource {

        $this->workflowService->reject(
            $signal,
            auth()->user(),
        );

        return new SignalResource(
            $signal->fresh()->load([
                'symbol',
                'creator',
                'approver',
                'histories',
            ])
        );
    }

    /**
     * Run AI historical confirmation.
     *
     * AI analyzes actual historical trading data.
     *
     * AI does NOT:
     * - approve the signal
     * - reject the signal
     * - publish the signal
     * - block the signal
     *
     * It only provides:
     * - historical score
     * - review
     * - evidence-based comment
     * - historical statistics
     */
    public function aiConfirmation(
        Signal $signal
    ): JsonResponse {

        $analysis = $this->workflowService
            ->runAiConfirmation(
                $signal,
                auth()->user(),
            );

        return response()->json([
            'message' => 'AI historical analysis completed.',

            'data' => [
                'signal' => new SignalResource(
                    $signal->fresh()->load([
                        'symbol',
                        'creator',
                        'approver',
                        'histories',
                    ])
                ),

                'ai' => [
                    'score' => $analysis['score'],
                    'review' => $analysis['review'],
                    'comment' => $analysis['comment'],
                    'historical' => $analysis['historical'],
                ],
            ],
        ]);
    }

    /**
     * Publish signal.
     *
     * Publishing remains an administrative decision.
     */
    public function publish(
        Signal $signal
    ): SignalResource {

        $this->workflowService->publish(
            $signal,
            auth()->user(),
        );

        return new SignalResource(
            $signal->fresh()->load([
                'symbol',
                'creator',
                'approver',
                'histories',
            ])
        );
    }

    /**
     * Start signal.
     */
    public function start(
        Signal $signal
    ): SignalResource {

        $this->workflowService->start(
            $signal,
            auth()->user(),
        );

        return new SignalResource(
            $signal->fresh()->load([
                'symbol',
                'creator',
                'approver',
                'histories',
            ])
        );
    }

    /**
     * TP1 Hit.
     */
    public function tp1(
        Signal $signal
    ): SignalResource {

        $this->workflowService->tp1(
            $signal,
            auth()->user(),
        );

        return new SignalResource(
            $signal->fresh()->load([
                'symbol',
                'creator',
                'approver',
                'histories',
            ])
        );
    }

    /**
     * TP2 Hit.
     */
    public function tp2(
        Signal $signal
    ): SignalResource {

        $this->workflowService->tp2(
            $signal,
            auth()->user(),
        );

        return new SignalResource(
            $signal->fresh()->load([
                'symbol',
                'creator',
                'approver',
                'histories',
            ])
        );
    }

    /**
     * TP3 Hit.
     */
    public function tp3(
        Signal $signal
    ): SignalResource {

        $this->workflowService->tp3(
            $signal,
            auth()->user(),
        );

        return new SignalResource(
            $signal->fresh()->load([
                'symbol',
                'creator',
                'approver',
                'histories',
            ])
        );
    }

    /**
     * Close signal.
     */
    public function close(
        Request $request,
        Signal $signal
    ): SignalResource {

        $validated = $request->validate([
            'result' => 'required|in:win,loss,breakeven',
            'pips' => 'required|integer',
        ]);

        $this->workflowService->close(
            $signal,
            auth()->user(),
            $validated['result'],
            $validated['pips'],
        );

        return new SignalResource(
            $signal->fresh()->load([
                'symbol',
                'creator',
                'approver',
                'histories',
            ])
        );
    }

    /**
     * Archive signal.
     */
    public function archive(
        Signal $signal
    ): SignalResource {

        $this->workflowService->archive(
            $signal,
            auth()->user(),
        );

        return new SignalResource(
            $signal->fresh()->load([
                'symbol',
                'creator',
                'approver',
                'histories',
            ])
        );
    }
}