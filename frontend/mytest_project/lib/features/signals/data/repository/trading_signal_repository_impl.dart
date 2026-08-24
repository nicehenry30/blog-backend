import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

import '../../domain/entities/ai_signal_confirmation.dart';
import '../../domain/entities/trading_signal.dart';
import '../../domain/repository/trading_signal_repository.dart';

import '../datasources/trading_signal_remote_data_source.dart';

class TradingSignalRepositoryImpl
    implements TradingSignalRepository {
  final TradingSignalRemoteDataSource remoteDataSource;

  const TradingSignalRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<TradingSignal>>> getSignals() async {
    try {
      final signals = await remoteDataSource.getSignals();

      return Right(signals);
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
  Future<Either<Failure, TradingSignal>> getSignalDetails(
    int signalId,
  ) async {
    try {
      final signal =
          await remoteDataSource.getSignalDetails(signalId);

      return Right(signal);
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
  Future<Either<Failure, AiSignalConfirmation>>
      getAiConfirmation(
    int signalId,
  ) async {
    try {
      final confirmation =
          await remoteDataSource.getAiConfirmation(signalId);

      return Right(confirmation);
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