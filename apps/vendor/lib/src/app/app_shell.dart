import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';
import '../screens/splash_screen.dart';
import '../screens/vendor_shell.dart';
import 'app_state.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);

    if (!state.hasSeenOnboarding) {
      return const SplashScreen(next: SplashNext.onboarding);
    }

    if (!state.isLoggedIn) {
      return const SplashScreen(next: SplashNext.auth);
    }

    return const VendorShell();
  }
}

class NiraiScaffoldHeader extends StatelessWidget {
  const NiraiScaffoldHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: text.headlineMedium),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72)),
          ),
        ],
      ],
    );
  }
}
