import 'package:flutter/material.dart';

import '../screens/auth_screen.dart';
import '../screens/client_shell.dart';
import '../screens/onboarding_screen.dart';
import '../screens/splash_screen.dart';
import 'app_state.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);

    Widget next;
    if (!state.hasCompletedOnboarding) {
      next = const OnboardingScreen();
    } else if (!state.isLoggedIn) {
      next = const AuthScreen();
    } else {
      next = const ClientShell();
    }

    return SplashScreen(next: next);
  }
}
