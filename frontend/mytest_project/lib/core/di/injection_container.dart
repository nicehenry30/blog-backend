import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:mytest_project/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mytest_project/features/auth/data/repository/auth_repository_impl.dart';
import 'package:mytest_project/features/auth/domain/repository/auth_repository.dart';
import 'package:mytest_project/features/auth/domain/usecases/user_log_in.dart';
import 'package:mytest_project/features/auth/domain/usecases/user_sign_up.dart';
import 'package:mytest_project/features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

void initDependencies() {
  // HTTP Client
  serviceLocator.registerLazySingleton<http.Client>(() => http.Client());

  // Data Source
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator()),
  );

  // Use Cases
  serviceLocator.registerLazySingleton<UserSignUp>(
    () => UserSignUp(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<UserLogIn>(
    () => UserLogIn(serviceLocator()),
  );

  // BLoC
  serviceLocator.registerFactory<AuthBloc>(
    () => AuthBloc(userSignUp: serviceLocator(), userLogIn: serviceLocator()),
  );
}
