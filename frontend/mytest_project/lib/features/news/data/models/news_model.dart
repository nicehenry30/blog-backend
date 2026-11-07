import '../../domain/entities/news.dart';

class NewsModel extends News {
  const NewsModel({
    required super.id,
    required super.marketauxUuid,
    required super.title,
    required super.description,
    required super.url,
    required super.source,
    required super.publishedAt,
    required super.imageUrl,
    required super.symbols,
    required super.currencies,
    required super.entities,
    required super.sentiment,
    required super.sentimentScore,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as int,
      marketauxUuid: json['marketaux_uuid'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      url: json['url'] as String? ?? '',
      source: json['source'] as String?,
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'] as String)
          : null,
      imageUrl: json['image_url'] as String?,
      symbols: List<String>.from(json['symbols'] ?? const []),
      currencies: List<String>.from(json['currencies'] ?? const []),
      entities: List<Map<String, dynamic>>.from(
        (json['entities'] ?? const []).map(
          (entity) => Map<String, dynamic>.from(entity),
        ),
      ),
      sentiment: json['sentiment'] as String?,
      sentimentScore: (json['sentiment_score'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marketaux_uuid': marketauxUuid,
      'title': title,
      'description': description,
      'url': url,
      'source': source,
      'published_at': publishedAt?.toIso8601String(),
      'image_url': imageUrl,
      'symbols': symbols,
      'currencies': currencies,
      'entities': entities,
      'sentiment': sentiment,
      'sentiment_score': sentimentScore,
    };
  }
}
