import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entities/news.dart';
import '../repository/news_repository.dart';

class GetNews
    implements UseCase<List<News>, NoParams> {
  final NewsRepository repository;

  const GetNews(this.repository);

  @override
  Future<Either<Failure, List<News>>> call(
    NoParams params,
  ) async {
    return repository.getNews();
  }
}