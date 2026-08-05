<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreSignalRequest;
use App\Models\Signal;
use App\Models\Symbol;
use Illuminate\Http\RedirectResponse;
use Illuminate\View\View;

class SignalController extends Controller
{
    /**
     * Display all signals.
     */
    public function index(): View
    {
        $signals = Signal::with([
            'symbol',
            'creator',
        ])
        ->latest()
        ->paginate(10);

        return view(
            'admin.signals.index',
            compact('signals')
        );
    }

    /**
     * Show create form.
     */
    public function create(): View
    {
        $symbols = Symbol::active()
            ->orderBy('asset_type')
            ->orderBy('symbol')
            ->get()
            ->groupBy('asset_type');

        return view(
            'admin.signals.create',
            compact('symbols')
        );
    }

    /**
     * Store signal.
     */
    public function store(StoreSignalRequest $request): RedirectResponse
    {
        $data = $request->validated();

        $data['created_by'] = auth()->id() ?? 1;

        $data['status'] = $request->input('action', 'Draft');

        if ($data['status'] === 'Published') {
            $data['published_at'] = now();
        }

        if ($request->hasFile('chart_image')) {
            $data['chart_image'] = $request
                ->file('chart_image')
                ->store('signals', 'public');
        }

        Signal::create($data);

        return redirect()
            ->route('admin.signals.index')
            ->with(
                'success',
                'Signal created successfully.'
            );
    }

    /**
     * Show edit form.
     */
    public function edit(Signal $signal): View
        {
        $symbols = Symbol::active()
            ->orderBy('asset_type')
            ->orderBy('symbol')
            ->get()
            ->groupBy('asset_type');

        return view(
            'admin.signals.edit',
            compact(
                'signal',
                'symbols'
            )
        );
    }

    /**
     * Update signal.
     */
    public function update(
    StoreSignalRequest $request,
    Signal $signal
    ): 
    RedirectResponse {

    $data = $request->validated();

    if ($request->hasFile('chart_image')) {

        $data['chart_image'] = $request
            ->file('chart_image')
            ->store('signals', 'public');

    }

    if ($request->filled('action')) {

        $data['status'] = $request->action;

        if ($request->action === 'Published') {
            $data['published_at'] = now();
        }

    }

    $signal->update($data);

    return redirect()
        ->route('admin.signals.index')
        ->with(
            'success',
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
     * Publish signal.
     */
    public function publish(
        Signal $signal
    ): RedirectResponse {

        $signal->publish();

        return redirect()
            ->route('admin.signals.index')
            ->with(
                'success',
                'Signal published successfully.'
            );
    }
}