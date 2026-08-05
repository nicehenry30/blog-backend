<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StorePlanRequest extends FormRequest
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
            'name' => [
                'required',
                'string',
                'max:100',
            ],

            'slug' => [
                'required',
                'string',
                'max:100',
                'unique:plans,slug',
            ],

            'description' => [
                'nullable',
                'string',
            ],

            'price' => [
                'required',
                'numeric',
                'min:0',
            ],

            'currency' => [
                'required',
                'string',
                'max:10',
            ],

            'billing_cycle' => [
                'required',
                'in:monthly,yearly,lifetime',
            ],

            'is_active' => [
                'required',
                'boolean',
            ],

            'sort_order' => [
                'required',
                'integer',
                'min:1',
            ],
        ];
    }
}