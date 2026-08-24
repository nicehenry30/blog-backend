<?php

namespace App\Services;

use Illuminate\Http\Client\RequestException;
use Illuminate\Support\Facades\Http;

class PaystackService
{
    /**
     * Initialize a Paystack transaction.
     */
    public function initializeTransaction(array $data): array
    {
        try {

            $response = Http::withToken(
                config('services.paystack.secret_key')
            )
                ->timeout(30)
                ->acceptJson()
                ->post(
                    config('services.paystack.base_url')
                    . '/transaction/initialize',
                    [
                        'email' => $data['email'],

                        /*
                         * Amount must be sent in the
                         * smallest unit of the currency.
                         *
                         * USD:
                         * $19.99 = 1999 cents
                         *
                         * NGN:
                         * ₦19.99 = 1999 kobo
                         */
                        'amount' => $data['amount'],

                        /*
                         * Explicitly specify the currency.
                         *
                         * Example:
                         * USD
                         * NGN
                         */
                        'currency' => $data['currency'],

                        'reference' => $data['reference'],

                        'callback_url' => $data['callback_url'],

                        'metadata' => $data['metadata'] ?? [],
                    ]
                );

            $response->throw();

            return $response->json();

        } catch (RequestException $e) {

            $paystackResponse =
                $e->response?->json();

            return [
                'status' => false,

                /*
                 * Return Paystack's actual error message.
                 */
                'message' =>
                    $paystackResponse['message']
                    ?? 'Unable to initialize payment.',

                /*
                 * Keep the complete Paystack response
                 * available for debugging.
                 */
                'error' => $paystackResponse,
            ];
        }
    }

    /**
     * Verify a Paystack transaction.
     */
    public function verifyTransaction(
        string $reference
    ): array {
        try {

            $response = Http::withToken(
                config('services.paystack.secret_key')
            )
                ->timeout(30)
                ->acceptJson()
                ->get(
                    config('services.paystack.base_url')
                    . "/transaction/verify/{$reference}"
                );

            $response->throw();

            return $response->json();

        } catch (RequestException $e) {

            $paystackResponse =
                $e->response?->json();

            return [
                'status' => false,

                /*
                 * Return Paystack's actual error message.
                 */
                'message' =>
                    $paystackResponse['message']
                    ?? 'Unable to verify payment.',

                /*
                 * Keep the complete response
                 * available for debugging.
                 */
                'error' => $paystackResponse,
            ];
        }
    }
}