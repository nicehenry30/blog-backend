<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\UpdatePaymentRequest;
use App\Models\Payment;
use App\Services\PaymentService;
use Illuminate\Http\RedirectResponse;

class PaymentController extends Controller
{
    /**
     * Payment service.
     */
    public function __construct(
        protected PaymentService $paymentService
    ) {
    }

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
            'reviewer',
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

    /**
     * Approve a manual crypto payment.
     *
     * The PaymentService handles:
     * - Payment completion
     * - Subscription activation
     * - Previous subscription cancellation
     * - Referral reward processing
     * - Crypto auto-renewal protection
     */
    public function approveCrypto(
        Payment $payment
    ): RedirectResponse {
        try {
            $this->paymentService->approveCryptoPayment(
                $payment,
                auth()->user()
            );

            return redirect()
                ->route(
                    'admin.payments.show',
                    $payment
                )
                ->with(
                    'success',
                    'Crypto payment approved and subscription activated successfully.'
                );
        } catch (\RuntimeException $e) {
            return redirect()
                ->route(
                    'admin.payments.show',
                    $payment
                )
                ->with(
                    'error',
                    $e->getMessage()
                );
        }
    }

    /**
     * Reject a manual crypto payment.
     */
    public function rejectCrypto(
        Payment $payment
    ): RedirectResponse {
        try {
            $this->paymentService->rejectCryptoPayment(
                $payment,
                auth()->user()
            );

            return redirect()
                ->route(
                    'admin.payments.show',
                    $payment
                )
                ->with(
                    'success',
                    'Crypto payment rejected successfully.'
                );
        } catch (\RuntimeException $e) {
            return redirect()
                ->route(
                    'admin.payments.show',
                    $payment
                )
                ->with(
                    'error',
                    $e->getMessage()
                );
        }
    }
}