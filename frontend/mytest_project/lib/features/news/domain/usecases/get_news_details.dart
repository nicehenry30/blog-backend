import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entities/news.dart';
import '../repository/news_repository.dart';

class GetNewsDetails
    implements UseCase<News, int> {
  final NewsRepository repository;

  const GetNewsDetails(this.repository);

  @override
  Future<Either<Failure, News>> call(
    int newsId,
  ) async {
    return repository.getNewsDetails(
      newsId,
    );
  }
}