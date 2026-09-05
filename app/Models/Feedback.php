<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Feedback extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'category',
        'subject',
        'message',
        'admin_reply',
        'status',
        'replied_at',
    ];

    protected $casts = [
        'replied_at' => 'datetime',
    ];

    /**
     * User who submitted the feedback.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Check whether an admin has replied.
     */
    public function hasReply(): bool
    {
        return ! empty($this->admin_reply);
    }

    /**
     * Check whether the feedback is resolved.
     */
    public function isResolved(): bool
    {
        return in_array(
            $this->status,
            ['resolved', 'closed'],
            true
        );
    }
}