import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/core/di/injection_container.dart';
import 'package:mytest_project/core/notifications/push_notification_service.dart';
import 'package:mytest_project/features/notifications/domain/usecases/register_device_token.dart';

import '../bloc/auth_bloc.dart';
import 'login_page.dart';
import 'main_navigation.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is AuthAuthenticated) {
          return AuthenticatedNotificationInitializer(
            child: MainNavigation(
              name: state.user.name,
              email: state.user.email,
            ),
          );
        }

        if (state is AuthUnauthenticated) {
          return const LoginPage();
        }

        if (state is AuthFailure) {
          return Scaffold(
            body: Center(
              child: Text(
                state.message,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return const LoginPage();
      },
    );
  }
}

class AuthenticatedNotificationInitializer extends StatefulWidget {
  final Widget child;

  const AuthenticatedNotificationInitializer({
    super.key,
    required this.child,
  });

  @override
  State<AuthenticatedNotificationInitializer> createState() =>
      _AuthenticatedNotificationInitializerState();
}

class _AuthenticatedNotificationInitializerState
    extends State<AuthenticatedNotificationInitializer> {
  @override
  void initState() {
    super.initState();

    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    final notificationService =
        serviceLocator<PushNotificationService>();

    final registerDeviceToken =
        serviceLocator<RegisterDeviceToken>();

    await notificationService.initialize(
      onTokenReceived: (token) async {
        await registerDeviceToken(
          fcmToken: token,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}