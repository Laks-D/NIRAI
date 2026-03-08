import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../app/app_state.dart';
import '../widgets/quiet_card.dart';
import 'client_shell.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  bool _sentOtp = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

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
              Text('Sign in', style: text.displaySmall),
              const SizedBox(height: 8),
              Text(
                'India-first phone OTP, or continue as guest.',
                style: text.bodyLarge?.copyWith(color: NiraiTheme.primary.withOpacity(0.78)),
              ),
              const SizedBox(height: 16),

              QuietCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone', style: text.titleMedium),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'e.g. +91 98765 43210',
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_sentOtp) ...[
                      Text('OTP', style: text.titleMedium),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: '6-digit OTP (mock)'),
                      ),
                      const SizedBox(height: 12),
                    ],

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: NiraiTheme.accent,
                                foregroundColor: NiraiTheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
                                ),
                              ),
                              onPressed: () {
                                if (!_sentOtp) {
                                  setState(() => _sentOtp = true);
                                  return;
                                }
                                state.loginWithPhone(_phoneController.text.trim());
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute<void>(builder: (_) => const ClientShell()),
                                );
                              },
                              child: Text(_sentOtp ? 'Verify & continue' : 'Send OTP'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            state.continueAsGuest();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(builder: (_) => const ClientShell()),
                            );
                          },
                          child: const Text('Guest'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'Session persistence is mocked for MVP scaffold.',
                      style: text.bodySmall?.copyWith(color: NiraiTheme.primary.withOpacity(0.65)),
                    ),
                  ],
                ),
              ),

              const Spacer(),
              Text(
                'By continuing, you agree to basic terms (stub).',
                style: text.bodySmall?.copyWith(color: NiraiTheme.primary.withOpacity(0.65)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
