<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class SignalResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     */
    public function toArray(Request $request): array
    {
        return [

            'id' => $this->id,

            /*
            |--------------------------------------------------------------------------
            | Trading Symbol
            |--------------------------------------------------------------------------
            */

            'symbol' => [
                'id' => $this->symbol?->id,
                'symbol' => $this->symbol?->symbol,
                'name' => $this->symbol?->name,
                'asset_type' => $this->symbol?->asset_type,
                'broker_symbol' => $this->symbol?->broker_symbol,
                'digits' => $this->symbol?->digits,
            ],

            /*
            |--------------------------------------------------------------------------
            | Signal Details
            |--------------------------------------------------------------------------
            */

            'direction' => $this->direction,

            'entry_price' => (float) $this->entry_price,

            'stop_loss' => (float) $this->stop_loss,

            'take_profit' => (float) $this->take_profit,

            'timeframe' => $this->timeframe,

            /*
            |--------------------------------------------------------------------------
            | Analysis
            |--------------------------------------------------------------------------
            */

            'signal_quality' => (float) $this->signal_quality,

            'overall_confidence' => (float) $this->overall_confidence,

            'strategy' => $this->strategy,

            'confluences' => $this->confluences ?? [],

            /*
            |--------------------------------------------------------------------------
            | Chart
            |--------------------------------------------------------------------------
            */

            'chart_image' => $this->chart_image,

            'chart_image_url' => $this->chart_image
                ? Storage::url($this->chart_image)
                : null,

            /*
            |--------------------------------------------------------------------------
            | Status
            |--------------------------------------------------------------------------
            */

            'status' => $this->status,

            'published_at' => optional(
                $this->published_at
            )->toIso8601String(),

            /*
            |--------------------------------------------------------------------------
            | Creator
            |--------------------------------------------------------------------------
            */

            'created_by' => [
                'id' => $this->creator?->id,
                'name' => $this->creator?->name,
            ],

            /*
            |--------------------------------------------------------------------------
            | Dates
            |--------------------------------------------------------------------------
            */

            'created_at' => optional(
                $this->created_at
            )->toIso8601String(),

            'updated_at' => optional(
                $this->updated_at
            )->toIso8601String(),
        ];
    }
}