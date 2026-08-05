<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdatePaymentRequest extends FormRequest
{
    /**
     * Determine if the user is authorized.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Validation rules.
     */
    public function rules(): array
    {
        return [
            'status' => [
                'required',
                'in:pending,successful,failed,refunded',
            ],

            'reference' => [
                'nullable',
                'string',
                'max:255',
            ],

            'gateway_reference' => [
                'nullable',
                'string',
                'max:255',
            ],
        ];
    }
}