import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';

import '../../domain/entities/news.dart';

import '../../domain/usecases/get_news.dart';
import '../../domain/usecases/get_news_details.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNews getNews;

  final GetNewsDetails getNewsDetails;

  NewsBloc({
    required this.getNews,
    required this.getNewsDetails,
  }) : super(NewsInitial()) {
    on<LoadNews>(
      _onLoadNews,
    );

    on<LoadNewsDetails>(
      _onLoadNewsDetails,
    );
  }

  Future<void> _onLoadNews(
    LoadNews event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());

    final result = await getNews(
      NoParams(),
    );

    result.fold(
      (failure) => emit(
        NewsFailure(
          failure.message,
        ),
      ),
      (news) => emit(
        NewsLoaded(news),
      ),
    );
  }

  Future<void> _onLoadNewsDetails(
    LoadNewsDetails event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());

    final result = await getNewsDetails(
      event.newsId,
    );

    result.fold(
      (failure) => emit(
        NewsFailure(
          failure.message,
        ),
      ),
      (news) => emit(
        NewsDetailsLoaded(news),
      ),
    );
  }
}