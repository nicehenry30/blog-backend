import 'package:fpdart/fpdart.dart';
import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/core/usecase/usecase.dart';
import 'package:mytest_project/features/journal/domain/repository/journal_repository.dart';

class DeleteTrade implements UseCase<void, int> {
  final JournalRepository repository;

  DeleteTrade(this.repository);

  @override
  Future<Either<Failure, void>> call(int tradeId) async {
    return await repository.deleteTrade(tradeId);
  }
}