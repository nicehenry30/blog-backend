class News {
  final int id;
  final String? marketauxUuid;
  final String title;
  final String? description;
  final String url;
  final String? source;
  final DateTime? publishedAt;
  final String? imageUrl;
  final List<String> symbols;
  final List<String> currencies;
  final List<Map<String, dynamic>> entities;
  final String? sentiment;
  final double? sentimentScore;

  const News({
    required this.id,
    required this.marketauxUuid,
    required this.title,
    required this.description,
    required this.url,
    required this.source,
    required this.publishedAt,
    required this.imageUrl,
    required this.symbols,
    required this.currencies,
    required this.entities,
    required this.sentiment,
    required this.sentimentScore,
  });
}
