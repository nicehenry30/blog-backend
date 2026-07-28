import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytest_project/core/di/injection_container.dart';
import 'package:mytest_project/core/theme/theme.dart';
import 'package:mytest_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mytest_project/features/auth/presentation/pages/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<AuthBloc>()
        ..add(const AuthCheckStatus()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkThemeMode,
        home: const AuthGate(),
      ),
    );
  }
}