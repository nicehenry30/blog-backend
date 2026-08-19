<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;
use App\Models\Plan;
use App\Services\SubscriptionService;
use App\Http\Resources\SignalHistoryResource;

class SignalResource extends JsonResource
{
    /**

    
     * Transform the resource into an array.
     */
    public function toArray(Request $request): array
    {
        $canView = true;

        if (auth()->check()) {
            $canView = app(SubscriptionService::class)
                ->canViewSignal(
                    auth()->user(),
                    $this->resource
                );
        }

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

            'take_profit_2' => $this->take_profit_2
                ? (float) $this->take_profit_2
                : null,

            'take_profit_3' => $this->take_profit_3
                ? (float) $this->take_profit_3
                : null,

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

            'analysis' => $this->analysis,

            'ai_score' => $this->ai_score !== null
                ? (float) $this->ai_score
                : null,

            'ai_comment' => $this->ai_comment,

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

            'visibility' => $this->visibility,

            'auto_executable' => (bool) $this->auto_executable,

            'locked' => !$canView,

            'can_view' => $canView,

            'upgrade_plan' => match ($this->visibility) {

                Plan::FREE => null,

                Plan::PREMIUM => 'Premium',

               Plan::PRO => 'Prop Firm',

                default => null,

            },

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

            'histories' => SignalHistoryResource::collection(
            $this->whenLoaded('histories')
             ),

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