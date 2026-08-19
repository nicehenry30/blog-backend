<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreSignalRequest;
use App\Models\Signal;
use App\Models\Symbol;
use App\Models\User;
use App\Services\SignalHistoryService;
use App\Services\SignalWorkflowService;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;
use Illuminate\View\View;

class SignalController extends Controller
{
    public function __construct(
        protected SignalWorkflowService $workflowService,
        protected SignalHistoryService $historyService,
    ) {
    }

    /**
     * Temporary Admin User.
     * Remove after Admin Authentication is implemented.
     */
    protected function adminUser(): User
    {
        return User::findOrFail(
            auth()->id() ?? 1
        );
    }

    /**
     * Active symbols grouped by asset type.
     */
    protected function symbols(): Collection
    {
        return Symbol::active()
            ->orderBy('asset_type')
            ->orderBy('symbol')
            ->get()
            ->groupBy('asset_type');
    }

    /**
     * Display all signals.
     */
    public function index(Request $request): View
    {
        $query = Signal::with(
            Signal::DEFAULT_RELATIONS
        );

        /*
        |--------------------------------------------------------------------------
        | Filters
        |--------------------------------------------------------------------------
        */

        if ($request->filled('search')) {

            $query->whereHas(
                'symbol',
                function ($q) use ($request) {

                    $q->where(
                        'symbol',
                        'like',
                        '%' . $request->search . '%'
                    );

                }
            );

        }

        if ($request->filled('status')) {

            $query->where(
                'status',
                $request->status
            );

        }

        if ($request->filled('direction')) {

            $query->where(
                'direction',
                $request->direction
            );

        }

        if ($request->filled('timeframe')) {

            $query->where(
                'timeframe',
                $request->timeframe
            );

        }

        $signals = $query
            ->latest()
            ->paginate(20)
            ->withQueryString();

        $drafts = Signal::where(
            'status',
            Signal::STATUS_DRAFT
        )->count();

        $approved = Signal::where(
            'status',
            Signal::STATUS_APPROVED
        )->count();

        $published = Signal::where(
            'status',
            Signal::STATUS_PUBLISHED
        )->count();

        $running = Signal::where(
            'status',
            Signal::STATUS_RUNNING
        )->count();

        $closed = Signal::where(
            'status',
            Signal::STATUS_CLOSED
        )->count();

        return view(
            'admin.signals.index',
            compact(
                'signals',
                'drafts',
                'approved',
                'published',
                'running',
                'closed',
            )
        );
    }

    /**
     * Show create form.
     */
    public function create(): View
    {
        return view(
            'admin.signals.create',
            [
                'symbols' => $this->symbols(),
            ]
        );
    }

    /**
     * Store a new signal.
     */
    public function store(
        StoreSignalRequest $request
    ): RedirectResponse {

        $data = $request->validated();

        $data['created_by'] = $this->adminUser()->id;

        $this->handleChartUpload(
            $request,
            $data
        );

        $signal = Signal::create($data);

        return $this->redirectToSignal(
            $signal,
            'Signal created successfully.'
        );
    }

    /**
     * Display a signal.
     */
    public function show(
        Signal $signal
    ): View {

        $signal->load([
            'symbol',
            'creator',
            'approver',
            'histories.user',
        ]);

        return view(
            'admin.signals.show',
            compact('signal')
        );
    }

    /**
     * Show edit form.
     */
    public function edit(
        Signal $signal
    ): View {

        return view(
            'admin.signals.edit',
            [
                'signal' => $signal,
                'symbols' => $this->symbols(),
            ]
        );
    }

    /**
     * Update signal.
     */
    public function update(
        StoreSignalRequest $request,
        Signal $signal
    ): RedirectResponse {

        $data = $request->validated();

        $this->handleChartUpload(
            $request,
            $data
        );

        $signal->update($data);

        return $this->redirectToSignal(
            $signal,
            'Signal updated successfully.'
        );
    }

    /**
     * Delete signal.
     */
    public function destroy(
        Signal $signal
    ): RedirectResponse {

        $signal->delete();

        return redirect()
            ->route('admin.signals.index')
            ->with(
                'success',
                'Signal deleted successfully.'
            );
    }
        /**
     * Approve signal.
     */
    public function approve(
        Signal $signal
    ): RedirectResponse {

        $this->workflowService->approve(
            $signal,
            $this->adminUser()
        );

        return $this->redirectToSignal(
            $signal,
            'Signal approved successfully.'
        );
    }

    /**
     * Reject signal.
     */
    public function reject(
        Signal $signal
    ): RedirectResponse {

        $this->workflowService->reject(
            $signal,
            $this->adminUser()
        );

        return $this->redirectToSignal(
            $signal,
            'Signal rejected successfully.'
        );
    }

    /**
     * Publish signal.
     */
    public function publish(
        Signal $signal
    ): RedirectResponse {

        $this->workflowService->publish(
            $signal,
            $this->adminUser()
        );

        return $this->redirectToSignal(
            $signal,
            'Signal published successfully.'
        );
    }

    /**
     * Start signal.
     */
    public function start(
        Signal $signal
    ): RedirectResponse {

        $this->workflowService->start(
            $signal,
            $this->adminUser()
        );

        return $this->redirectToSignal(
            $signal,
            'Signal started successfully.'
        );
    }

    /**
     * Record TP1.
     */
    public function tp1(
        Signal $signal
    ): RedirectResponse {

        $this->workflowService->tp1(
            $signal,
            $this->adminUser()
        );

        return $this->redirectToSignal(
            $signal,
            'TP1 recorded successfully.'
        );
    }

    /**
     * Record TP2.
     */
    public function tp2(
        Signal $signal
    ): RedirectResponse {

        $this->workflowService->tp2(
            $signal,
            $this->adminUser()
        );

        return $this->redirectToSignal(
            $signal,
            'TP2 recorded successfully.'
        );
    }

    /**
     * Record TP3.
     */
    public function tp3(
        Signal $signal
    ): RedirectResponse {

        $this->workflowService->tp3(
            $signal,
            $this->adminUser()
        );

        return $this->redirectToSignal(
            $signal,
            'TP3 recorded successfully.'
        );
    }

        /**
     * Show close signal form.
     */
    public function closeForm(
        Signal $signal
    ): View
    {
        return view(
            'admin.signals.close',
            compact('signal')
        );
    }

    /**
     * Close signal.
     */
    public function close(
        Request $request,
        Signal $signal
    ): RedirectResponse {

        $validated = $request->validate([
            'result' => 'required|in:win,loss,breakeven',
            'pips' => 'required|integer',
        ]);

        $this->workflowService->close(
            $signal,
            $this->adminUser(),
            $validated['result'],
            $validated['pips']
        );

        return $this->redirectToSignal(
            $signal,
            'Signal closed successfully.'
        );
    }

    /**
     * Archive signal.
     */
    public function archive(
        Signal $signal
    ): RedirectResponse {

        $this->workflowService->archive(
            $signal,
            $this->adminUser()
        );

        return redirect()
            ->route('admin.signals.index')
            ->with(
                'success',
                'Signal archived successfully.'
            );
    }

    /**
     * Redirect back to the signal details page.
     */
    protected function redirectToSignal(
        Signal $signal,
        string $message
    ): RedirectResponse {

        return redirect()
            ->route('admin.signals.show', $signal)
            ->with(
                'success',
                $message
            );
    }

    /**
     * Handle chart image upload.
     */
    protected function handleChartUpload(
        StoreSignalRequest $request,
        array &$data
    ): void {

        if (! $request->hasFile('chart_image')) {
            return;
        }

        $data['chart_image'] = $request
            ->file('chart_image')
            ->store('signals', 'public');
    }
}