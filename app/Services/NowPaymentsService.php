<?php

namespace App\Services;

use Illuminate\Http\Client\RequestException;
use Illuminate\Support\Facades\Http;

class NowPaymentsService
{
    /**
     * Create a NOWPayments crypto payment.
     */
    public function createPayment(array $data): array
    {
        try {
            $response = Http::withHeaders([
                'x-api-key' => config('services.nowpayments.api_key'),
                'Content-Type' => 'application/json',
            ])
                ->timeout(30)
                ->acceptJson()
                ->post(
                    config('services.nowpayments.base_url') . '/v1/payment',
                    [
                        'price_amount' => $data['price_amount'],
                        'price_currency' => $data['price_currency'],
                        'pay_currency' => $data['pay_currency'],
                        'ipn_callback_url' => $data['ipn_callback_url'],
                        'order_id' => $data['order_id'],
                        'order_description' => $data['order_description'] ?? null,
                    ]
                );

            $response->throw();

            return $response->json();

        } catch (RequestException $e) {
            return [
                'status' => false,
                'message' => 'Unable to create crypto payment.',
                'error' => $e->response?->json(),
            ];
        }
    }

    /**
     * Get the current status of a NOWPayments payment.
     */
    public function getPaymentStatus(string $paymentId): array
    {
        try {
            $response = Http::withHeaders([
                'x-api-key' => config('services.nowpayments.api_key'),
            ])
                ->timeout(30)
                ->acceptJson()
                ->get(
                    config('services.nowpayments.base_url')
                    . "/v1/payment/{$paymentId}"
                );

            $response->throw();

            return $response->json();

        } catch (RequestException $e) {
            return [
                'status' => false,
                'message' => 'Unable to retrieve crypto payment status.',
                'error' => $e->response?->json(),
            ];
        }
    }

    /**
     * Get available cryptocurrencies.
     */
    public function getCurrencies(): array
    {
        try {
            $response = Http::withHeaders([
                'x-api-key' => config('services.nowpayments.api_key'),
            ])
                ->timeout(30)
                ->acceptJson()
                ->get(
                    config('services.nowpayments.base_url')
                    . '/v1/currencies'
                );

            $response->throw();

            return $response->json();

        } catch (RequestException $e) {
            return [
                'status' => false,
                'message' => 'Unable to retrieve available cryptocurrencies.',
                'error' => $e->response?->json(),
            ];
        }
    }
}