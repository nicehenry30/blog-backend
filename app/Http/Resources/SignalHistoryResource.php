<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SignalHistoryResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,

            'signal_id' => $this->signal_id,

            'user_id' => $this->user_id,

            'event' => $this->event,

            'old_status' => $this->old_status,

            'new_status' => $this->new_status,

            'description' => $this->description,

            'metadata' => $this->metadata,

            'created_at' => optional(
                $this->created_at
            )->toIso8601String(),
        ];
    }
}