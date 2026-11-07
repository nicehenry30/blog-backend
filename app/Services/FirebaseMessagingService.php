<?php

namespace App\Services;

use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

class FirebaseMessagingService
{
    private Messaging $messaging;

    public function __construct()
    {
        $this->messaging = (new Factory)
            ->withServiceAccount(config('services.firebase.credentials'))
            ->createMessaging();
    }

    public function sendToToken(
        string $token,
        string $title,
        string $body,
        array $data = []
    ): void {
        $message = CloudMessage::withTarget('token', $token)
            ->withNotification(
                Notification::create($title, $body)
            )
            ->withData($data);

        $this->messaging->send($message);
    }
}