import 'package:fpdart/fpdart.dart';
import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/core/usecase/usecase.dart';
import 'package:mytest_project/features/journal/domain/entities/trade.dart';
import 'package:mytest_project/features/journal/domain/repository/journal_repository.dart';

class GetTrades implements UseCase<List<Trade>, NoParams> {
final JournalRepository journalRepository;

GetTrades(this.journalRepository);

@override
Future<Either<Failure, List<Trade>>> call(NoParams params) {
return journalRepository.getTrades();
}
}
