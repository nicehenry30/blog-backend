<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Payment;
use App\Services\PaymentService;
use App\Services\PaystackService;
use Illuminate\Http\Request;

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
     * List authenticated user's payments.
     */
    public function index(Request $request)
    {
        $payments = $request->user()
            ->payments()
            ->with([
                'subscription.plan',
            ])
            ->latest()
            ->get();

        return response()->json([
            'data' => $payments,
        ]);
    }

    /**
     * Show a single payment.
     */
    public function show(Payment $payment)
    {
        $payment->load([
            'subscription.plan',
        ]);

        return response()->json([
            'data' => $payment,
        ]);
    }

    /**
     * Initialize a Paystack payment.
     */
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

    /**
     * Verify a payment using its Paystack reference.
     */
    public function verify(Request $request)
    {
        $validated = $request->validate([
            'reference' => [
                'required',
                'string',
            ],
        ]);

        $payment = Payment::where(
            'reference',
            $validated['reference']
        )->first();

        if (! $payment) {
            return response()->json([
                'message' => 'Payment not found.',
            ], 404);
        }

        $response = $this->paystackService
            ->verifyTransaction($payment->reference);

        if (
            isset($response['status']) &&
            $response['status'] === true &&
            isset($response['data']['status']) &&
            $response['data']['status'] === 'success'
        ) {
            $this->paymentService->completePayment(
                $payment,
                $response['data']['reference'],
                $response['data']
            );

            return response()->json([
                'message' => 'Payment verified successfully.',
                'subscription' => $payment
                    ->subscription
                    ->fresh(),
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
     * Handle Paystack webhook.
     */
    public function webhook(Request $request)
    {
        $signature = $request->header(
            'x-paystack-signature'
        );

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
            ! isset($payload['event']) ||
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

        if (! $payment) {
            return response()->json([
                'message' => 'Payment not found.',
            ], 404);
        }

        if ($payment->status === 'successful') {
            return response()->json([
                'message' => 'Already processed.',
            ]);
        }

        $this->paymentService->completePayment(
            $payment,
            $payload['data']['id'],
            $payload['data']
        );

        return response()->json([
            'message' => 'Webhook processed successfully.',
        ]);
    }
}