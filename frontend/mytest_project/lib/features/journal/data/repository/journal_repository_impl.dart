import 'package:fpdart/fpdart.dart';
import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/features/journal/data/datasources/journal_remote_data_source.dart';
import 'package:mytest_project/features/journal/domain/entities/trade.dart';
import 'package:mytest_project/features/journal/domain/repository/journal_repository.dart';

class JournalRepositoryImpl implements JournalRepository {
  final JournalRemoteDataSource remoteDataSource;

  JournalRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, List<Trade>>> getTrades() async {
    try {
      final trades = await remoteDataSource.getTrades();

      return Right(trades);
    } on ServerException catch (e) {
      return Left(
        Failure(e.message),
      );
    } catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> addTrade(
    Trade trade,
  ) async {
    try {
      await remoteDataSource.addTrade(
        trade,
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        Failure(e.message),
      );
    } catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateTrade(
    Trade trade,
  ) async {
    try {
      await remoteDataSource.updateTrade(
        trade,
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        Failure(e.message),
      );
    } catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteTrade(
    int tradeId,
  ) async {
    try {
      await remoteDataSource.deleteTrade(
        tradeId,
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        Failure(e.message),
      );
    } catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }
}