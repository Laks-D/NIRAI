import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../app/app_state.dart';
import '../widgets/quiet_card.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final state = AppStateScope.of(context);

    return Scaffold(
      backgroundColor: NiraiTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome', style: text.displaySmall),
              const SizedBox(height: 10),
              Text(
                'Hyper-local vendors. Quiet luxury. Low power.',
                style: text.bodyLarge?.copyWith(color: NiraiTheme.primary.withOpacity(0.78)),
              ),
              const SizedBox(height: 16),

              QuietCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location (coarse)', style: text.titleMedium),
                    const SizedBox(height: 6),
                    Text(
                      'We show neighborhood-level hexes to keep things private.',
                      style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.78)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              QuietCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notifications', style: text.titleMedium),
                    const SizedBox(height: 6),
                    Text(
                      'Get a quiet ping when favorites are nearby (optional).',
                      style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.78)),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: NiraiTheme.accent,
                    foregroundColor: NiraiTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
                    ),
                  ),
                  onPressed: () {
                    state.completeOnboarding();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(builder: (_) => const AuthScreen()),
                    );
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
