import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================================
// CORE
// ============================================================================

import 'package:mytest_project/core/storage/local_storage.dart';
import 'package:mytest_project/core/storage/local_storage_impl.dart';

// ============================================================================
// AUTH FEATURE
// ============================================================================

import 'package:mytest_project/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mytest_project/features/auth/data/repository/auth_repository_impl.dart';
import 'package:mytest_project/features/auth/domain/repository/auth_repository.dart';
import 'package:mytest_project/features/auth/domain/usecases/user_get_current_user.dart';
import 'package:mytest_project/features/auth/domain/usecases/user_log_in.dart';
import 'package:mytest_project/features/auth/domain/usecases/user_log_out.dart';
import 'package:mytest_project/features/auth/domain/usecases/user_sign_up.dart';
import 'package:mytest_project/features/auth/presentation/bloc/auth_bloc.dart';

// ============================================================================
// JOURNAL FEATURE
// ============================================================================

import 'package:mytest_project/features/journal/data/datasources/journal_remote_data_source.dart';
import 'package:mytest_project/features/journal/data/repository/journal_repository_impl.dart';
import 'package:mytest_project/features/journal/domain/repository/journal_repository.dart';
import 'package:mytest_project/features/journal/domain/usecases/add_trade.dart';
import 'package:mytest_project/features/journal/domain/usecases/get_trades.dart';
import 'package:mytest_project/features/journal/domain/usecases/update_trade.dart';
import 'package:mytest_project/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:mytest_project/features/journal/domain/usecases/delete_trade.dart';

// ============================================================================
// SETTINGS FEATURE
// ============================================================================

import 'package:mytest_project/features/settings/data/datasources/trading_settings_local_data_source.dart';
import 'package:mytest_project/features/settings/data/repository/trading_settings_repository_impl.dart';

import 'package:mytest_project/features/settings/domain/usecases/get_trading_settings.dart';
import 'package:mytest_project/features/settings/domain/usecases/save_trading_settings.dart';
import 'package:mytest_project/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:mytest_project/features/settings/domain/repository/trading_settings_repository.dart';

// ============================================================================
// DASHBOARD FEATURE
// ============================================================================

import 'package:mytest_project/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:mytest_project/features/dashboard/data/repository/dashboard_repository_impl.dart';

import 'package:mytest_project/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:mytest_project/features/dashboard/domain/usecases/get_dashboard.dart';

import 'package:mytest_project/features/dashboard/presentation/bloc/dashboard_bloc.dart';

// ============================================================================
// RISK SETTINGS FEATURE
// ============================================================================

import 'package:mytest_project/features/risk_settings/data/datasources/risk_settings_remote_data_source.dart';
import 'package:mytest_project/features/risk_settings/data/repository/risk_settings_repository_impl.dart';

import 'package:mytest_project/features/risk_settings/domain/repository/risk_settings_repository.dart';
import 'package:mytest_project/features/risk_settings/domain/usecases/get_risk_settings.dart';
import 'package:mytest_project/features/risk_settings/domain/usecases/update_risk_settings.dart';

import 'package:mytest_project/features/risk_settings/presentation/bloc/risk_settings_bloc.dart';

// ============================================================================
// GUARDIAN FEATURE
// ============================================================================

import 'package:mytest_project/features/guardian/data/datasources/guardian_remote_data_source.dart';
import 'package:mytest_project/features/guardian/data/repository/guardian_repository_impl.dart';

import 'package:mytest_project/features/guardian/domain/repository/guardian_repository.dart';
import 'package:mytest_project/features/guardian/domain/usecases/get_guardian_account.dart';

import 'package:mytest_project/features/guardian/presentation/bloc/guardian_bloc.dart';
import 'package:mytest_project/features/guardian/domain/usecases/generate_guardian_connection_code.dart';
import 'package:mytest_project/features/guardian/domain/usecases/disconnect_guardian.dart';

// ============================================================================
// EDUCATION FEATURE
// ============================================================================

import 'package:mytest_project/features/education/data/datasources/education_remote_data_source.dart';

import 'package:mytest_project/features/education/domain/usecases/get_courses.dart';
import 'package:mytest_project/features/education/domain/usecases/get_course_details.dart';
import 'package:mytest_project/features/education/domain/usecases/get_lessons.dart';
import 'package:mytest_project/features/education/domain/usecases/get_progress.dart';
import 'package:mytest_project/features/education/domain/usecases/update_progress.dart';

import 'package:mytest_project/features/education/presentation/bloc/education_bloc.dart';

// ============================================================================
// NEWS FEATURE
// ============================================================================

import 'package:mytest_project/features/news/data/datasources/news_remote_data_source.dart';
import 'package:mytest_project/features/news/data/repository/news_repository_impl.dart';

import 'package:mytest_project/features/news/domain/repository/news_repository.dart';

import 'package:mytest_project/features/news/domain/usecases/get_news.dart';
import 'package:mytest_project/features/news/domain/usecases/get_news_details.dart';

import 'package:mytest_project/features/news/presentation/bloc/news_bloc.dart';

// ============================================================================
// SIGNALS FEATURE
// ============================================================================

import 'package:mytest_project/features/signals/data/datasources/trading_signal_remote_data_source.dart';
import 'package:mytest_project/features/signals/data/repository/trading_signal_repository_impl.dart';

import 'package:mytest_project/features/signals/domain/repository/trading_signal_repository.dart';

import 'package:mytest_project/features/signals/domain/usecases/get_trading_signals.dart';
import 'package:mytest_project/features/signals/domain/usecases/get_trading_signal_details.dart';

import 'package:mytest_project/features/signals/presentation/bloc/trading_signal_bloc.dart';

// ============================================================================
// SUBSCRIPTION FEATURE
// ============================================================================

import 'package:mytest_project/features/subscription/data/datasources/subscription_remote_data_source.dart';
import 'package:mytest_project/features/subscription/data/datasources/subscription_remote_data_source_impl.dart';

import 'package:mytest_project/features/subscription/data/repositories/subscription_repository_impl.dart';

import 'package:mytest_project/features/subscription/domain/repositories/subscription_repository.dart';

import 'package:mytest_project/features/subscription/domain/usecases/get_plans.dart';
import 'package:mytest_project/features/subscription/domain/usecases/get_current_subscription.dart';
import 'package:mytest_project/features/subscription/domain/usecases/initialize_payment.dart';
import 'package:mytest_project/features/subscription/domain/usecases/verify_payment.dart';

import 'package:mytest_project/features/subscription/presentation/bloc/subscription_bloc.dart';

// ============================================================================
// PAYMENTS FEATURE
// ============================================================================

import 'package:mytest_project/features/payments/data/datasources/payment_remote_data_source.dart';
import 'package:mytest_project/features/payments/data/datasources/payment_remote_data_source_impl.dart';

import 'package:mytest_project/features/payments/data/repositories/payment_repository_impl.dart';

import 'package:mytest_project/features/payments/domain/repositories/payment_repository.dart';

import 'package:mytest_project/features/payments/domain/usecases/get_payment.dart';
import 'package:mytest_project/features/payments/domain/usecases/get_payments.dart';

import 'package:mytest_project/features/payments/presentation/bloc/payment_bloc.dart';

import 'package:mytest_project/features/market_alerts/data/datasources/market_alert_remote_data_source.dart';
import 'package:mytest_project/features/market_alerts/data/datasources/market_alert_remote_data_source_impl.dart';
import 'package:mytest_project/features/market_alerts/data/repositories/market_alert_repository_impl.dart';
import 'package:mytest_project/features/market_alerts/domain/repositories/market_alert_repository.dart';
import 'package:mytest_project/features/market_alerts/domain/usecases/get_market_alerts.dart';
import 'package:mytest_project/features/market_alerts/presentation/bloc/market_alert_bloc.dart';

import 'package:mytest_project/features/education/data/repository/education_repository_impl.dart';
import 'package:mytest_project/features/education/domain/repository/education_repository.dart';

// ============================================================================
// NOTIFICATIONS FEATURE
// ============================================================================

import 'package:mytest_project/core/notifications/push_notification_service.dart';

import 'package:mytest_project/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:mytest_project/features/notifications/data/repository/notification_repository_impl.dart';

import 'package:mytest_project/features/notifications/domain/repository/notification_repository.dart';
import 'package:mytest_project/features/notifications/domain/usecases/register_device_token.dart';

import 'package:mytest_project/features/auto_trading/data/datasources/auto_trading_remote_data_source.dart';
import 'package:mytest_project/features/auto_trading/data/repository/auto_trading_repository_impl.dart';
import 'package:mytest_project/features/auto_trading/domain/repository/auto_trading_repository.dart';
import 'package:mytest_project/features/auto_trading/domain/usecases/get_auto_trading_status.dart';
import 'package:mytest_project/features/auto_trading/domain/usecases/update_auto_trading.dart';
import 'package:mytest_project/features/auto_trading/presentation/bloc/auto_trading_bloc.dart';
import 'package:mytest_project/features/auto_trading/domain/usecases/update_auto_trading_preferences.dart';

import 'package:mytest_project/features/signals/domain/usecases/get_ai_signal_confirmation.dart';

import 'package:mytest_project/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mytest_project/features/profile/data/repository/profile_repository_impl.dart';
import 'package:mytest_project/features/profile/domain/repository/profile_repository.dart';
import 'package:mytest_project/features/profile/domain/usecases/get_profile.dart';
import 'package:mytest_project/features/profile/domain/usecases/update_profile.dart';
import 'package:mytest_project/features/profile/presentation/bloc/profile_bloc.dart';
// ============================================================================
// SERVICE LOCATOR
// ============================================================================

final serviceLocator = GetIt.instance;

// ============================================================================
// INITIALIZE DEPENDENCIES
// ============================================================================

Future<void> initDependencies() async {
  // ==========================================================================
  // SHARED PREFERENCES
  // ==========================================================================

  final sharedPreferences = await SharedPreferences.getInstance();

  serviceLocator.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );

  // ==========================================================================
  // TRADING SETTINGS
  // ==========================================================================

  serviceLocator.registerLazySingleton<TradingSettingsLocalDataSource>(
    () => TradingSettingsLocalDataSource(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<TradingSettingsRepository>(
    () => TradingSettingsRepositoryImpl(serviceLocator()),
  );

  // ==========================================================================
  // TRADING SETTINGS USE CASES
  // ==========================================================================

  serviceLocator.registerLazySingleton<GetTradingSettings>(
    () => GetTradingSettings(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<SaveTradingSettings>(
    () => SaveTradingSettings(serviceLocator()),
  );

  // ==========================================================================
  // LOCAL STORAGE
  // ==========================================================================

  serviceLocator.registerLazySingleton<LocalStorage>(
    () => LocalStorageImpl(serviceLocator()),
  );

  // ==========================================================================
  // HTTP CLIENT
  // ==========================================================================

  serviceLocator.registerLazySingleton<http.Client>(() => http.Client());

  // ==========================================================================
  // AUTH FEATURE
  // ==========================================================================

  // --------------------------------------------------------------------------
  // Auth Remote Data Source
  // --------------------------------------------------------------------------

  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator()),
  );

  // --------------------------------------------------------------------------
  // Auth Repository
  // --------------------------------------------------------------------------

  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
  );

  // --------------------------------------------------------------------------
  // Auth Use Cases
  // --------------------------------------------------------------------------

  serviceLocator.registerLazySingleton<UserSignUp>(
    () => UserSignUp(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<UserLogIn>(
    () => UserLogIn(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<UserLogOut>(
    () => UserLogOut(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<UserGetCurrentUser>(
    () => UserGetCurrentUser(serviceLocator()),
  );

  // ==========================================================================
  // SETTINGS BLOC
  // ==========================================================================

  serviceLocator.registerFactory<SettingsBloc>(
    () => SettingsBloc(
      getTradingSettings: serviceLocator(),
      saveTradingSettings: serviceLocator(),
    ),
  );

  // --------------------------------------------------------------------------
  // Auth BLoC
  // --------------------------------------------------------------------------

  serviceLocator.registerFactory<AuthBloc>(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogIn: serviceLocator(),
      userLogOut: serviceLocator(),
      userGetCurrentUser: serviceLocator(),
    ),
  );

  // ==========================================================================
  // JOURNAL FEATURE
  // ==========================================================================

  // --------------------------------------------------------------------------
  // Journal Remote Data Source
  // --------------------------------------------------------------------------

  serviceLocator.registerLazySingleton<JournalRemoteDataSource>(
    () => JournalRemoteDataSourceImpl(serviceLocator(), serviceLocator()),
  );

  // --------------------------------------------------------------------------
  // Journal Repository
  // --------------------------------------------------------------------------

  serviceLocator.registerLazySingleton<JournalRepository>(
    () => JournalRepositoryImpl(serviceLocator()),
  );

  // --------------------------------------------------------------------------
  // Journal Use Cases
  // --------------------------------------------------------------------------

  serviceLocator.registerLazySingleton<GetTrades>(
    () => GetTrades(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<AddTrade>(
    () => AddTrade(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<UpdateTrade>(
    () => UpdateTrade(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<DeleteTrade>(
    () => DeleteTrade(serviceLocator()),
  );

  // --------------------------------------------------------------------------
  // Journal BLoC
  // --------------------------------------------------------------------------

  serviceLocator.registerFactory<JournalBloc>(
    () => JournalBloc(
      getTrades: serviceLocator(),
      addTrade: serviceLocator(),
      updateTrade: serviceLocator(),
      deleteTrade: serviceLocator(),
    ),
  );

  // ==========================================================================
  // DASHBOARD FEATURE
  // ==========================================================================

  // --------------------------------------------------------------------------
  // Dashboard Remote Data Source
  // --------------------------------------------------------------------------

  serviceLocator.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(serviceLocator(), serviceLocator()),
  );

  // --------------------------------------------------------------------------
  // Dashboard Repository
  // --------------------------------------------------------------------------

  serviceLocator.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(serviceLocator()),
  );

  // --------------------------------------------------------------------------
  // Dashboard Use Case
  // --------------------------------------------------------------------------

  serviceLocator.registerLazySingleton<GetDashboard>(
    () => GetDashboard(serviceLocator()),
  );

  // --------------------------------------------------------------------------
  // Dashboard BLoC
  // --------------------------------------------------------------------------

  serviceLocator.registerFactory<DashboardBloc>(
    () => DashboardBloc(getDashboard: serviceLocator()),
  );

  // ==========================================================================
  // RISK SETTINGS FEATURE
  // ==========================================================================

  // --------------------------------------------------------------------------
  // Risk Settings Remote Data Source
  // --------------------------------------------------------------------------

  serviceLocator.registerLazySingleton<RiskSettingsRemoteDataSource>(
    () => RiskSettingsRemoteDataSourceImpl(serviceLocator(), serviceLocator()),
  );

  // --------------------------------------------------------------------------
  // Risk Settings Repository
  // --------------------------------------------------------------------------

  serviceLocator.registerLazySingleton<RiskSettingsRepository>(
    () => RiskSettingsRepositoryImpl(serviceLocator()),
  );

  // --------------------------------------------------------------------------
  // Risk Settings Use Cases
  // --------------------------------------------------------------------------

  serviceLocator.registerLazySingleton<GetRiskSettings>(
    () => GetRiskSettings(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<UpdateRiskSettings>(
    () => UpdateRiskSettings(serviceLocator()),
  );

  // --------------------------------------------------------------------------
  // Risk Settings BLoC
  // --------------------------------------------------------------------------

  serviceLocator.registerFactory<RiskSettingsBloc>(
    () => RiskSettingsBloc(
      getRiskSettings: serviceLocator(),
      updateRiskSettings: serviceLocator(),
    ),
  );

 
  // --------------------------------------------------------------------------
  // Notification Remote Data Source
  // --------------------------------------------------------------------------

  serviceLocator.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(
      serviceLocator<http.Client>(),
      serviceLocator<LocalStorage>(),
    ),
  );

  // --------------------------------------------------------------------------
  // Notification Repository
  // --------------------------------------------------------------------------

  serviceLocator.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      serviceLocator<NotificationRemoteDataSource>(),
    ),
  );

  // --------------------------------------------------------------------------
  // Notification Use Cases
  // --------------------------------------------------------------------------

  serviceLocator.registerLazySingleton<RegisterDeviceToken>(
    () => RegisterDeviceToken(
      serviceLocator<NotificationRepository>(),
    ),
  );

  // --------------------------------------------------------------------------
  // Push Notification Service
  // --------------------------------------------------------------------------

  serviceLocator.registerLazySingleton<PushNotificationService>(
    () => PushNotificationService(),
  );
// ==========================================================================
// GUARDIAN FEATURE
// ==========================================================================

// --------------------------------------------------------------------------
// Guardian Remote Data Source
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<GuardianRemoteDataSource>(
  () => GuardianRemoteDataSourceImpl(
    serviceLocator(),
    serviceLocator(),
  ),
);

// --------------------------------------------------------------------------
// Guardian Repository
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<GuardianRepository>(
  () => GuardianRepositoryImpl(
    serviceLocator(),
  ),
);

// --------------------------------------------------------------------------
// Guardian Use Cases
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<GetGuardianAccount>(
  () => GetGuardianAccount(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<
    GenerateGuardianConnectionCode>(
  () => GenerateGuardianConnectionCode(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<DisconnectGuardian>(
  () => DisconnectGuardian(
    serviceLocator(),
  ),
);

// --------------------------------------------------------------------------
// Guardian BLoC
// --------------------------------------------------------------------------

serviceLocator.registerFactory<GuardianBloc>(
  () => GuardianBloc(
    getGuardianAccount: serviceLocator(),
    generateGuardianConnectionCode:
        serviceLocator(),
    disconnectGuardian: serviceLocator(),
  ),
);

// ==========================================================================
// EDUCATION FEATURE
// ==========================================================================

// --------------------------------------------------------------------------
// Education Remote Data Source
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<EducationRemoteDataSource>(
  () => EducationRemoteDataSourceImpl(
    serviceLocator(),
    serviceLocator(),
  ),
);

// --------------------------------------------------------------------------
// Education Remote Data Source
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<EducationRepository>(
  () => EducationRepositoryImpl(
    serviceLocator(),
  ),
);


serviceLocator.registerLazySingleton<GetCourses>(
  () => GetCourses(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<GetCourseDetails>(
  () => GetCourseDetails(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<GetLessons>(
  () => GetLessons(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<GetProgress>(
  () => GetProgress(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<UpdateProgress>(
  () => UpdateProgress(
    serviceLocator(),
  ),
);

// --------------------------------------------------------------------------
// Education BLoC
// --------------------------------------------------------------------------

serviceLocator.registerFactory(
  () => EducationBloc(
    getCourses: serviceLocator(),
    getCourseDetails: serviceLocator(),
    getLessons: serviceLocator(),
  ),
);

// ==========================================================================
// NEWS FEATURE
// ==========================================================================

// --------------------------------------------------------------------------
// News Remote Data Source
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<NewsRemoteDataSource>(
  () => NewsRemoteDataSourceImpl(),
);

// --------------------------------------------------------------------------
// News Repository
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<NewsRepository>(
  () => NewsRepositoryImpl(
    remoteDataSource: serviceLocator(),
  ),
);

// --------------------------------------------------------------------------
// News Use Cases
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<GetNews>(
  () => GetNews(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<GetNewsDetails>(
  () => GetNewsDetails(
    serviceLocator(),
  ),
);

// --------------------------------------------------------------------------
// News BLoC
// --------------------------------------------------------------------------

serviceLocator.registerFactory<NewsBloc>(
  () => NewsBloc(
    getNews: serviceLocator(),
    getNewsDetails: serviceLocator(),
  ),
);

// ==========================================================================
// SIGNALS FEATURE
// ==========================================================================

// --------------------------------------------------------------------------
// Signals Remote Data Source
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<
    TradingSignalRemoteDataSource>(
  () => TradingSignalRemoteDataSourceImpl(
    serviceLocator(),
    serviceLocator(),
  ),
);

// --------------------------------------------------------------------------
// Signals Repository
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<
    TradingSignalRepository>(
  () => TradingSignalRepositoryImpl(
    remoteDataSource: serviceLocator(),
  ),
);

// --------------------------------------------------------------------------
// Signals Use Cases
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<
    GetTradingSignals>(
  () => GetTradingSignals(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<
    GetTradingSignalDetails>(
  () => GetTradingSignalDetails(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<
    GetAiSignalConfirmation>(
  () => GetAiSignalConfirmation(
    serviceLocator(),
  ),
);



// --------------------------------------------------------------------------
// Signals BLoC
// --------------------------------------------------------------------------

serviceLocator.registerFactory<TradingSignalBloc>(
  () => TradingSignalBloc(
    getTradingSignals: serviceLocator(),
    getTradingSignalDetails: serviceLocator(),
    getAiConfirmation: serviceLocator(),
  ),
);

// ==========================================================================
// SUBSCRIPTION FEATURE
// ==========================================================================

// --------------------------------------------------------------------------
// Subscription Remote Data Source
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<SubscriptionRemoteDataSource>(
  () => SubscriptionRemoteDataSourceImpl(
    serviceLocator(),
    serviceLocator(),
  ),
);

// --------------------------------------------------------------------------
// Subscription Repository
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<SubscriptionRepository>(
  () => SubscriptionRepositoryImpl(
    serviceLocator(),
  ),
);

// --------------------------------------------------------------------------
// Subscription Use Cases
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<GetPlans>(
  () => GetPlans(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<GetCurrentSubscription>(
  () => GetCurrentSubscription(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<InitializePayment>(
  () => InitializePayment(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<VerifyPayment>(
  () => VerifyPayment(
    serviceLocator(),
  ),
);


// --------------------------------------------------------------------------
// Subscription BLoC
// --------------------------------------------------------------------------

  serviceLocator.registerFactory<SubscriptionBloc>(
  () => SubscriptionBloc(
    getPlans: serviceLocator(),
    getCurrentSubscription: serviceLocator(),
    initializePayment: serviceLocator(),
    verifyPayment: serviceLocator(),
    ),
  );

  // ==========================================================================
// PAYMENTS FEATURE
// ==========================================================================

// --------------------------------------------------------------------------
// Payment Remote Data Source
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<PaymentRemoteDataSource>(
  () => PaymentRemoteDataSourceImpl(
    serviceLocator(),
    serviceLocator(),
  ),
);

// --------------------------------------------------------------------------
// Payment Repository
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<PaymentRepository>(
  () => PaymentRepositoryImpl(
    serviceLocator(),
  ),
);

// --------------------------------------------------------------------------
// Payment Use Cases
// --------------------------------------------------------------------------

serviceLocator.registerLazySingleton<GetPayments>(
  () => GetPayments(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<GetPayment>(
  () => GetPayment(
    serviceLocator(),
  ),
);

// --------------------------------------------------------------------------
// Payment Bloc
// --------------------------------------------------------------------------

serviceLocator.registerFactory<PaymentBloc>(
  () => PaymentBloc(
    getPayments: serviceLocator(),
    getPayment: serviceLocator(),
  ),
);

// ============================================================
// MARKET ALERTS
// ============================================================

serviceLocator.registerLazySingleton<
    MarketAlertRemoteDataSource>(
  () => MarketAlertRemoteDataSourceImpl(
    serviceLocator(),
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<
    MarketAlertRepository>(
  () => MarketAlertRepositoryImpl(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton(
  () => GetMarketAlerts(
    serviceLocator(),
  ),
);

serviceLocator.registerFactory(
  () => MarketAlertBloc(
    getMarketAlerts: serviceLocator(),
  ),
);

// ==================================================
// AUTO TRADING
// ==================================================

serviceLocator.registerLazySingleton<
    AutoTradingRemoteDataSource>(
  () => AutoTradingRemoteDataSourceImpl(
    serviceLocator(),
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<AutoTradingRepository>(
  () => AutoTradingRepositoryImpl(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton(
  () => GetAutoTradingStatus(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton(
  () => UpdateAutoTrading(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton(
  () => UpdateAutoTradingPreferences(
    serviceLocator(),
  ),
);

serviceLocator.registerFactory(
  () => AutoTradingBloc(
    getAutoTradingStatus: serviceLocator(),
    updateAutoTrading: serviceLocator(),
    updateAutoTradingPreferences: serviceLocator(),
  ),
);

// ==========================================================================
// PROFILE
// ==========================================================================

serviceLocator.registerLazySingleton<ProfileRemoteDataSource>(
  () => ProfileRemoteDataSourceImpl(
    serviceLocator(),
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<ProfileRepository>(
  () => ProfileRepositoryImpl(
    serviceLocator(),
  ),
);

// ==========================================================================
// PROFILE USE CASES
// ==========================================================================

serviceLocator.registerLazySingleton<GetProfile>(
  () => GetProfile(
    serviceLocator(),
  ),
);

serviceLocator.registerLazySingleton<UpdateProfile>(
  () => UpdateProfile(
    serviceLocator(),
  ),
);

// ==========================================================================
// PROFILE BLOC
// ==========================================================================

serviceLocator.registerFactory<ProfileBloc>(
  () => ProfileBloc(
    getProfile: serviceLocator(),
    updateProfile: serviceLocator(),
  ),
);

}
