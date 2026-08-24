<?php

namespace App\Http\Controllers;

use App\Models\Payment;
use App\Services\PaymentService;
use App\Services\PaystackService;
use Illuminate\Http\Request;

class PaymentCallbackController extends Controller
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
     * Handle Paystack redirect callback.
     */
    public function handle(Request $request)
    {
        $reference = $request->query('reference');

        /*
         * Paystack must provide a reference.
         */
        if (! $reference) {
            return $this->redirectToFrontend(
                'failed',
                null,
                'Missing payment reference.'
            );
        }

        /*
         * Find our local payment using the exact
         * Paystack reference.
         */
        $payment = Payment::where(
            'reference',
            $reference
        )->first();

        if (! $payment) {
            return $this->redirectToFrontend(
                'failed',
                $reference,
                'Payment not found.'
            );
        }

        /*
         * Verify the transaction directly with Paystack.
         *
         * Never trust the browser redirect alone.
         */
        $response = $this->paystackService
            ->verifyTransaction($reference);

        /*
         * Paystack verification must succeed.
         */
        if (
            ! isset($response['status']) ||
            $response['status'] !== true ||
            ! isset($response['data'])
        ) {
            return $this->redirectToFrontend(
                'failed',
                $reference,
                'Payment verification failed.'
            );
        }

        $transaction = $response['data'];

        /*
         * Paystack transaction must actually be successful.
         */
        if (
            ! isset($transaction['status']) ||
            $transaction['status'] !== 'success'
        ) {
            return $this->redirectToFrontend(
                'failed',
                $reference,
                'Payment was not successful.'
            );
        }

        /*
         * Confirm that Paystack returned the SAME reference
         * that belongs to our local payment.
         */
        if (
            ! isset($transaction['reference']) ||
            $transaction['reference'] !== $payment->reference
        ) {
            return $this->redirectToFrontend(
                'failed',
                $reference,
                'Payment reference mismatch.'
            );
        }

        /*
         * Confirm the currency.
         */
        $expectedCurrency = strtoupper(
            $payment->gateway_currency
        );

        $actualCurrency = strtoupper(
            $transaction['currency'] ?? ''
        );

        if ($actualCurrency !== $expectedCurrency) {
            return $this->redirectToFrontend(
                'failed',
                $reference,
                'Payment currency mismatch.'
            );
        }

        /*
         * Confirm the amount.
         *
         * Our database stores gateway_amount in major
         * currency units:
         *
         * 26890.81 NGN
         *
         * Paystack returns the smallest unit:
         *
         * 2689081 kobo
         */
        $expectedGatewayAmount = (int) round(
            ((float) $payment->gateway_amount) * 100
        );

        $actualGatewayAmount = (int) (
            $transaction['amount'] ?? 0
        );

        if (
            $actualGatewayAmount !==
            $expectedGatewayAmount
        ) {
            return $this->redirectToFrontend(
                'failed',
                $reference,
                'Payment amount mismatch.'
            );
        }

        /*
         * Everything checks out.
         *
         * Complete the EXACT payment and therefore
         * activate the EXACT subscription attached to it.
         */
        try {
            $completedPayment = $this->paymentService
                ->completePayment(
                    $payment,
                    (string) (
                        $transaction['id']
                        ?? $transaction['reference']
                    ),
                    $transaction
                );
        } catch (\Throwable $e) {
            report($e);

            return $this->redirectToFrontend(
                'failed',
                $reference,
                'Payment was verified, but we could not complete the subscription.'
            );
        }

        /*
         * Payment successfully verified and completed.
         *
         * Redirect the customer back to the Flutter
         * Tradewisser application instead of rendering
         * a Laravel Blade page.
         */
        return $this->redirectToFrontend(
            'success',
            $completedPayment->reference
        );
    }

    /**
     * Redirect the customer back to the Flutter frontend.
     */
    protected function redirectToFrontend(
        string $status,
        ?string $reference = null,
        ?string $message = null
    ) {
        $frontendUrl = rtrim(
            config('app.frontend_url'),
            '/'
        );

        $url = $frontendUrl
            . '/payment/'
            . $status;

        $query = [];

        if ($reference) {
            $query['reference'] = $reference;
        }

        if ($message) {
            $query['message'] = $message;
        }

        if (! empty($query)) {
            $url .= '?' . http_build_query($query);
        }

        return redirect()->away($url);
    }
}