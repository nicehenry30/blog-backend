<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreSignalRequest extends FormRequest
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

            'symbol_id' => [
                'required',
                'exists:symbols,id',
            ],

            'direction' => [
                'required',
                'in:BUY,SELL',
            ],

            'entry_price' => [
                'required',
                'numeric',
            ],

            'stop_loss' => [
                'required',
                'numeric',
            ],

            'take_profit' => [
                'required',
                'numeric',
            ],

            'take_profit_2' => [
                'nullable',
                'numeric',
            ],

            'take_profit_3' => [
                'nullable',
                'numeric',
            ],

            'timeframe' => [
                'required',
                'string',
                'max:20',
            ],

            'signal_quality' => [
                'required',
                'numeric',
                'between:0,100',
            ],

            'overall_confidence' => [
                'required',
                'numeric',
                'between:0,100',
            ],

            'strategy' => [
                'nullable',
                'string',
                'max:100',
            ],

            'risk_reward' => [
                'nullable',
                'numeric',
            ],

            /*
            |--------------------------------------------------------------------------
            | Analysis & AI
            |--------------------------------------------------------------------------
            */

            'analysis' => [
                'nullable',
                'string',
            ],

            'ai_score' => [
                'nullable',
                'numeric',
                'between:0,100',
            ],

            'ai_comment' => [
                'nullable',
                'string',
            ],

            /*
            |--------------------------------------------------------------------------
            | Confluences
            |--------------------------------------------------------------------------
            */

            'confluences' => [
                'nullable',
                'array',
            ],

            'confluences.*' => [
                'string',
                'max:100',
            ],

            /*
            |--------------------------------------------------------------------------
            | Chart
            |--------------------------------------------------------------------------
            */

            'chart_image' => [
                'nullable',
                'image',
                'mimes:jpg,jpeg,png,webp',
                'max:4096',
            ],

            /*
            |--------------------------------------------------------------------------
            | Status
            |--------------------------------------------------------------------------
            */

            'status' => [
                'nullable',
                'in:Draft,Approved,Published,Running,Closed,Rejected,Cancelled,Expired',
            ],

            /*
            |--------------------------------------------------------------------------
            | Visibility
            |--------------------------------------------------------------------------
            */

            'visibility' => [
                'required',
                'in:free,premium,pro',
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

            'ai_score.between' =>
                'AI Score must be between 0 and 100.',

            'chart_image.image' =>
                'Chart image must be a valid image.',

            'chart_image.max' =>
                'Chart image cannot exceed 4MB.',
        ];
    }
}