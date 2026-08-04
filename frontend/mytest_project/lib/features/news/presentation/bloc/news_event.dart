part of 'news_bloc.dart';

sealed class NewsEvent {}

class LoadNews extends NewsEvent {}

class LoadNewsDetails extends NewsEvent {
  final int newsId;

  LoadNewsDetails(this.newsId);
}