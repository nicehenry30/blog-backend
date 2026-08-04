import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

import '../../domain/entities/news.dart';
import '../../domain/repository/news_repository.dart';

import '../datasources/news_remote_data_source.dart';

class NewsRepositoryImpl
    implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  const NewsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<News>>> getNews() async {
    try {
      final news = await remoteDataSource.getNews();

      return Right(news);
    } catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, News>> getNewsDetails(
    int newsId,
  ) async {
    try {
      final news = await remoteDataSource.getNewsDetails(
        newsId,
      );

      return Right(news);
    } catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }
}