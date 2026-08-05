<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Payment;
use App\Services\PaystackService;
use Illuminate\Http\Request;
use App\Services\PaymentService;

class PaymentController extends Controller
{
    protected PaystackService $paystackService;
    protected PaymentService $paymentService;

    public function __construct(
        PaystackService $paystackService,
        PaymentService $paymentService
    ) {
        $this->paystackService = $paystackService;
        $this->paymentService = $paymentService;
    }

    /**
     * Verify a completed payment.
     */
    public function verify(Request $request, Payment $payment)
    {
        $response = $this->paystackService
            ->verifyTransaction($payment->reference);

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

            return response()->json([
                'message' => 'Payment verified successfully.',
            ]);
        }

        $payment->update([
            'status' => 'failed',
        ]);

        return response()->json([
            'message' => 'Payment verification failed.',
        ], 400);
    }

    /**
     * Paystack webhook.
     */
        public function webhook(Request $request)
    {
        $signature = $request->header('x-paystack-signature');

        $secret = env('PAYSTACK_SECRET_KEY');

        $computedSignature = hash_hmac(
            'sha512',
            $request->getContent(),
            $secret
        );

        if ($signature !== $computedSignature) {
            return response()->json([
                'message' => 'Invalid signature.',
            ], 403);
        }

        $payload = $request->all();

        if (
            !isset($payload['event']) ||
            $payload['event'] !== 'charge.success'
        ) {
            return response()->json([
                'message' => 'Event ignored.',
            ]);
        }

        $reference = $payload['data']['reference'];

        $payment = Payment::where(
            'reference',
            $reference
        )->first();

        if (!$payment) {
            return response()->json([
                'message' => 'Payment not found.',
            ], 404);
        }

        if ($payment->status === 'successful') {
            return response()->json([
                'message' => 'Already processed.',
            ]);
        }

        $payment->update([
            'status' => 'successful',
            'transaction_id' => $payload['data']['id'],
            'gateway_response' => $payload['data'],
            'paid_at' => now(),
        ]);

        $payment->subscription->update([
            'status' => 'active',
            'starts_at' => now(),
            'expires_at' => now()->addMonth(),
        ]);

        return response()->json([
            'message' => 'Webhook processed successfully.',
        ]);
    }

        public function initialize(Request $request)
    {
        $validated = $request->validate([
            'plan_id' => [
                'required',
                'exists:plans,id',
            ],
        ]);

        return response()->json(
            $this->paymentService->initialize(
                $request->user(),
                $validated['plan_id']
            )
        );
    }

    
}