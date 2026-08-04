class News {
  final int id;

  final String title;

  final String currency;

  final String impactLevel;

  final String country;

  final DateTime eventDateTime;

  final String forecast;

  final String previous;

  final String? actual;

  final String description;

  final List<String> affectedPairs;

  final bool notification30Min;

  final bool notification5Min;

  final String status;

  const News({
    required this.id,
    required this.title,
    required this.currency,
    required this.impactLevel,
    required this.country,
    required this.eventDateTime,
    required this.forecast,
    required this.previous,
    required this.actual,
    required this.description,
    required this.affectedPairs,
    required this.notification30Min,
    required this.notification5Min,
    required this.status,
  });
}