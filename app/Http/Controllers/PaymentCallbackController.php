<?php

namespace App\Http\Controllers;

use App\Models\Payment;
use App\Services\PaystackService;
use Illuminate\Http\Request;

class PaymentCallbackController extends Controller
{
    protected PaystackService $paystackService;

    public function __construct(
        PaystackService $paystackService
    ) {
        $this->paystackService = $paystackService;
    }

    public function handle(Request $request)
    {
        $reference = $request->query('reference');

        if (!$reference) {
            return view('payment.failed', [
                'message' => 'Missing payment reference.',
            ]);
        }

        $payment = Payment::where(
            'reference',
            $reference
        )->first();

        if (!$payment) {
            return view('payment.failed', [
                'message' => 'Payment not found.',
            ]);
        }

        $response = $this->paystackService
            ->verifyTransaction($reference);

        if (
            isset($response['status']) &&
            $response['status'] === true &&
            isset($response['data']['status']) &&
            $response['data']['status'] === 'success'
        ) {

            $payment->update([
                'status' => 'successful',
                'transaction_id' => $response['data']['reference'],
                'gateway_response' => $response['data'],
                'paid_at' => now(),
            ]);

            $payment->subscription->update([
                'status' => 'active',
                'starts_at' => now(),
                'expires_at' => now()->addMonth(),
            ]);

            return view('payment.success', [
                'payment' => $payment,
            ]);
        }

        $payment->update([
            'status' => 'failed',
        ]);

        return view('payment.failed', [
            'message' => 'Payment verification failed.',
        ]);
    }
}