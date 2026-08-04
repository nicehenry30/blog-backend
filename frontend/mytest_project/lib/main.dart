import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/core/di/injection_container.dart';
import 'package:mytest_project/core/theme/theme.dart';

import 'package:mytest_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mytest_project/features/auth/presentation/pages/auth_gate.dart';

import 'package:mytest_project/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:mytest_project/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:mytest_project/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:mytest_project/features/risk_settings/presentation/bloc/risk_settings_bloc.dart';
import 'package:mytest_project/features/guardian/presentation/bloc/guardian_bloc.dart';
import 'package:mytest_project/features/education/presentation/bloc/education_bloc.dart';
import 'package:mytest_project/features/news/presentation/bloc/news_bloc.dart';
import 'package:mytest_project/features/signals/presentation/bloc/trading_signal_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => serviceLocator<AuthBloc>()
            ..add(const AuthCheckStatus()),
        ),

        BlocProvider<JournalBloc>(
          create: (_) => serviceLocator<JournalBloc>(),
        ),

        BlocProvider<DashboardBloc>(
          create: (_) => serviceLocator<DashboardBloc>(),
        ),

        BlocProvider<SettingsBloc>(
          create: (_) => serviceLocator<SettingsBloc>(),
        ),

        BlocProvider<RiskSettingsBloc>(
          create: (_) => serviceLocator<RiskSettingsBloc>(),
        ),

        BlocProvider<GuardianBloc>(
          create: (_) => serviceLocator<GuardianBloc>(),
        ),

        BlocProvider<EducationBloc>(
          create: (_) => serviceLocator<EducationBloc>(),
        ),

        BlocProvider<NewsBloc>(
          create: (_) => serviceLocator<NewsBloc>(),
        ),

        BlocProvider<TradingSignalBloc>(
          create: (_) => serviceLocator<TradingSignalBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkThemeMode,
        home: const AuthGate(),
      ),
    );
  }
}