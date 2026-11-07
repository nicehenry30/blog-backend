<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\News;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class NewsController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = News::query()
            ->orderByDesc('published_at');

        if ($request->filled('symbol')) {
            $symbol = strtoupper($request->string('symbol')->toString());

            $query->whereJsonContains('symbols', $symbol);
        }

        if ($request->filled('sentiment')) {
            $query->where(
                'sentiment',
                $request->string('sentiment')->toString()
            );
        }

        $limit = min(
            max((int) $request->input('limit', 20), 1),
            100
        );

        $news = $query
            ->limit($limit)
            ->get([
                'id',
                'marketaux_uuid',
                'title',
                'description',
                'url',
                'source',
                'published_at',
                'image_url',
                'symbols',
                'currencies',
                'entities',
                'sentiment',
                'sentiment_score',
            ]);

        return response()->json([
            'data' => $news,
            'meta' => [
                'count' => $news->count(),
                'limit' => $limit,
                'symbol' => $request->input('symbol'),
            ],
        ]);
    }
}