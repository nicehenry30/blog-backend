import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/news.dart';

abstract interface class NewsRepository {
  Future<Either<Failure, List<News>>> getNews();

  Future<Either<Failure, News>> getNewsDetails(
    int newsId,
  );
}
