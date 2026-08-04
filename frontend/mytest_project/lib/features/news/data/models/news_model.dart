import '../../domain/entities/news.dart';

class NewsModel extends News {
  const NewsModel({
    required super.id,
    required super.title,
    required super.currency,
    required super.impactLevel,
    required super.country,
    required super.eventDateTime,
    required super.forecast,
    required super.previous,
    required super.actual,
    required super.description,
    required super.affectedPairs,
    required super.notification30Min,
    required super.notification5Min,
    required super.status,
  });

  factory NewsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      currency: json['currency'],
      impactLevel: json['impact_level'],
      country: json['country'],
      eventDateTime: DateTime.parse(
        json['event_date_time'],
      ),
      forecast: json['forecast'],
      previous: json['previous'],
      actual: json['actual'],
      description: json['description'],
      affectedPairs: List<String>.from(
        json['affected_pairs'],
      ),
      notification30Min:
          json['notification_30_min'],
      notification5Min:
          json['notification_5_min'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'currency': currency,
      'impact_level': impactLevel,
      'country': country,
      'event_date_time':
          eventDateTime.toIso8601String(),
      'forecast': forecast,
      'previous': previous,
      'actual': actual,
      'description': description,
      'affected_pairs': affectedPairs,
      'notification_30_min':
          notification30Min,
      'notification_5_min':
          notification5Min,
      'status': status,
    };
  }
}