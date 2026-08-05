<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\UpdatePaymentRequest;
use App\Models\Payment;

class PaymentController extends Controller
{
    /**
     * Display all payments.
     */
    public function index()
    {
        $payments = Payment::with([
            'user',
            'plan',
        ])
        ->latest()
        ->paginate(20);

        return view(
            'admin.payments.index',
            compact('payments')
        );
    }

    /**
     * Display a payment.
     */
    public function show(Payment $payment)
    {
        $payment->load([
            'user',
            'plan',
        ]);

        return view(
            'admin.payments.show',
            compact('payment')
        );
    }

    /**
     * Show the edit form.
     */
    public function edit(Payment $payment)
    {
        return view(
            'admin.payments.edit',
            compact('payment')
        );
    }

    /**
     * Update the payment.
     */
    public function update(
        UpdatePaymentRequest $request,
        Payment $payment
    ) {
        $payment->update(
            $request->validated()
        );

        return redirect()
            ->route('admin.payments.index')
            ->with(
                'success',
                'Payment updated successfully.'
            );
    }

    /**
     * Delete a payment.
     */
    public function destroy(Payment $payment)
    {
        $payment->delete();

        return redirect()
            ->route('admin.payments.index')
            ->with(
                'success',
                'Payment deleted successfully.'
            );
    }
}