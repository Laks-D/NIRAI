import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import 'auth_screen.dart';
import 'onboarding_screen.dart';

enum SplashNext { onboarding, auth }

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.next});

  final SplashNext next;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;

    final route = widget.next == SplashNext.onboarding
        ? MaterialPageRoute<void>(builder: (_) => const OnboardingScreen())
        : MaterialPageRoute<void>(builder: (_) => const AuthScreen());

    Navigator.of(context).pushReplacement(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NiraiTheme.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: NiraiTheme.accent,
                borderRadius: BorderRadius.circular(NiraiTheme.radiusCard),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.storefront_outlined, color: NiraiTheme.primary, size: 34),
            ),
            const SizedBox(height: 16),
            Text('Nirai Vendor', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 10),
            SizedBox(
              width: 180,
              child: LinearProgressIndicator(
                minHeight: 5,
                backgroundColor: NiraiTheme.primary.withOpacity(0.08),
                color: NiraiTheme.primary.withOpacity(0.55),
                borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
