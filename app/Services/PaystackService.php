<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Http\Client\RequestException;

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
                config('services.paystack.base_url') . '/transaction/initialize',
                [
                    'email' => $data['email'],
                    'amount' => $data['amount'], // Kobo
                    'reference' => $data['reference'],
                    'callback_url' => $data['callback_url'],
                    'metadata' => $data['metadata'] ?? [],
                ]
            );

            $response->throw();

            return $response->json();

        } catch (RequestException $e) {

            return [
                'status' => false,
                'message' => 'Unable to initialize payment.',
                'error' => $e->response?->json(),
            ];
        }
    }

    /**
     * Verify a Paystack transaction.
     */
    public function verifyTransaction(string $reference): array
    {
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

            return [
                'status' => false,
                'message' => 'Unable to verify payment.',
                'error' => $e->response?->json(),
            ];
        }
    }
}