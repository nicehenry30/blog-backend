import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytest_project/core/di/injection_container.dart';
import 'package:mytest_project/core/theme/theme.dart';
import 'package:mytest_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mytest_project/features/auth/presentation/pages/login_page.dart';

void main() {
  initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<AuthBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Blog App',
        theme: AppTheme.darkThemeMode,
        home: const LoginPage(),
      ),
    );
  }
}
