import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mytest_project/core/storage/local_storage.dart';
import 'package:mytest_project/core/storage/local_storage_impl.dart';
import 'package:mytest_project/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mytest_project/features/auth/data/repository/auth_repository_impl.dart';
import 'package:mytest_project/features/auth/domain/repository/auth_repository.dart';
import 'package:mytest_project/features/auth/domain/usecases/user_get_current_user.dart';
import 'package:mytest_project/features/auth/domain/usecases/user_log_in.dart';
import 'package:mytest_project/features/auth/domain/usecases/user_log_out.dart';
import 'package:mytest_project/features/auth/domain/usecases/user_sign_up.dart';
import 'package:mytest_project/features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();

  serviceLocator.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );

  // Local Storage
  serviceLocator.registerLazySingleton<LocalStorage>(
    () => LocalStorageImpl(serviceLocator()),
  );

  // HTTP Client
  serviceLocator.registerLazySingleton<http.Client>(
    () => http.Client(),
  );

  // Data Source
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
      serviceLocator(),
    ),
  );

  // Sign Up
  serviceLocator.registerLazySingleton<UserSignUp>(
    () => UserSignUp(serviceLocator()),
  );

  // Log In
  serviceLocator.registerLazySingleton<UserLogIn>(
    () => UserLogIn(serviceLocator()),
  );

  // Log Out
  serviceLocator.registerLazySingleton<UserLogOut>(
    () => UserLogOut(serviceLocator()),
  );

  // Get Current User
  serviceLocator.registerLazySingleton<UserGetCurrentUser>(
    () => UserGetCurrentUser(serviceLocator()),
  );

  // BLoC
  serviceLocator.registerFactory<AuthBloc>(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogIn: serviceLocator(),
      userLogOut: serviceLocator(),
      userGetCurrentUser: serviceLocator(),
    ),
  );
}