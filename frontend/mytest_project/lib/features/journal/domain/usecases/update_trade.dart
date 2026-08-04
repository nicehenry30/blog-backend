import 'package:fpdart/fpdart.dart';
import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/core/usecase/usecase.dart';
import 'package:mytest_project/features/journal/domain/entities/trade.dart';
import 'package:mytest_project/features/journal/domain/repository/journal_repository.dart';

class UpdateTrade implements UseCase<void, Trade> {
  final JournalRepository journalRepository;

  UpdateTrade(this.journalRepository);

  @override
  Future<Either<Failure, void>> call(Trade trade) {
    return journalRepository.updateTrade(trade);
  }
}