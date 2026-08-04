part of 'news_bloc.dart';

sealed class NewsState {}

final class NewsInitial extends NewsState {}

final class NewsLoading extends NewsState {}

final class NewsLoaded extends NewsState {
  final List<News> news;

  NewsLoaded(this.news);
}

final class NewsDetailsLoaded extends NewsState {
  final News news;

  NewsDetailsLoaded(this.news);
}

final class NewsFailure extends NewsState {
  final String message;

  NewsFailure(this.message);
}