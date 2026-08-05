<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateSignalRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     */
    public function rules(): array
    {
        return [
            'symbol' => [
                'sometimes',
                'string',
                'max:20',
            ],

            'direction' => [
                'sometimes',
                'in:BUY,SELL',
            ],

            'entry_price' => [
                'sometimes',
                'numeric',
            ],

            'stop_loss' => [
                'sometimes',
                'numeric',
            ],

            'take_profit' => [
                'sometimes',
                'numeric',
            ],

            'timeframe' => [
                'sometimes',
                'string',
                'max:20',
            ],

            'signal_quality' => [
                'sometimes',
                'numeric',
                'between:0,100',
            ],

            'overall_confidence' => [
                'sometimes',
                'numeric',
                'between:0,100',
            ],

            'strategy' => [
                'nullable',
                'string',
                'max:100',
            ],

            'confluences' => [
                'nullable',
                'array',
            ],

            'confluences.*' => [
                'string',
                'max:100',
            ],

            'chart_image' => [
                'nullable',
                'image',
                'mimes:jpg,jpeg,png,webp',
                'max:4096',
            ],

            'status' => [
                'sometimes',
                'in:Draft,Pending,Published,Expired,Cancelled',
            ],
        ];
    }

    /**
     * Custom validation messages.
     */
    public function messages(): array
    {
        return [
            'direction.in' =>
                'Direction must be BUY or SELL.',

            'signal_quality.between' =>
                'Signal Quality must be between 0 and 100.',

            'overall_confidence.between' =>
                'Overall Confidence must be between 0 and 100.',

            'chart_image.image' =>
                'Chart image must be a valid image.',

            'chart_image.max' =>
                'Chart image cannot exceed 4MB.',
        ];
    }
}

