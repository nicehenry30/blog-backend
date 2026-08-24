<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PlanResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,

            'name' => $this->name,

            'slug' => $this->slug,

            'description' => $this->description,

            'price' => (float) $this->price,

            'currency' => $this->currency,

            'billing_cycle' => $this->billing_cycle,

            'is_active' => (bool) $this->is_active,

            'sort_order' => (int) $this->sort_order,

            'features' => $this->features
                ->where('enabled', true)
                ->pluck('feature')
                ->values(),
        ];
    }
}