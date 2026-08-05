<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Symbol;
use Illuminate\Http\Request;
use Illuminate\Http\RedirectResponse;
use Illuminate\View\View;

class SymbolController extends Controller
{
    /**
     * Display a listing of symbols.
     */
    public function index(): View
    {
        $symbols = Symbol::latest()
            ->paginate(15);

        return view(
            'admin.symbols.index',
            compact('symbols')
        );
    }

    /**
     * Show the create form.
     */
    public function create(): View
    {
        return view('admin.symbols.create');
    }

    /**
     * Store a newly created symbol.
     */
    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'symbol' => 'required|string|max:20|unique:symbols,symbol',
            'name' => 'required|string|max:100',
            'asset_type' => 'required|in:Forex,Metal,Crypto,Index,Commodity,Stock,ETF,Other',
            'broker_symbol' => 'nullable|string|max:50',
            'digits' => 'required|integer|min:0|max:8',
            'active' => 'nullable|boolean',
        ]);

        $validated['active'] = $request->boolean('active');

        Symbol::create($validated);

        return redirect()
            ->route('admin.symbols.index')
            ->with('success', 'Trading symbol created successfully.');
    }

    /**
     * Show the edit form.
     */
    public function edit(Symbol $symbol): View
    {
        return view(
            'admin.symbols.edit',
            compact('symbol')
        );
    }

    /**
     * Update the symbol.
     */
    public function update(Request $request, Symbol $symbol): RedirectResponse
    {
        $validated = $request->validate([
            'symbol' => 'required|string|max:20|unique:symbols,symbol,' . $symbol->id,
            'name' => 'required|string|max:100',
            'asset_type' => 'required|in:Forex,Metal,Crypto,Index,Commodity,Stock,ETF,Other',
            'broker_symbol' => 'nullable|string|max:50',
            'digits' => 'required|integer|min:0|max:8',
            'active' => 'nullable|boolean',
        ]);

        $validated['active'] = $request->boolean('active');

        $symbol->update($validated);

        return redirect()
            ->route('admin.symbols.index')
            ->with('success', 'Trading symbol updated successfully.');
    }

    /**
     * Delete the symbol.
     */
    public function destroy(Symbol $symbol): RedirectResponse
    {
        $symbol->delete();

        return redirect()
            ->route('admin.symbols.index')
            ->with('success', 'Trading symbol deleted successfully.');
    }
}