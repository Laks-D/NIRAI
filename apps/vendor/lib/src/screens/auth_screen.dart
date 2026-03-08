import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../app/app_state.dart';
import 'vendor_shell.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _phone.dispose();
    _otp.dispose();
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
              Text('Sign in', style: text.headlineLarge),
              const SizedBox(height: 6),
              Text(
                'Phone OTP · Device binding: ${state.boundDeviceId ?? '—'}',
                style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72)),
              ),
              const SizedBox(height: 18),
              _Field(
                label: 'Phone number',
                child: TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: _input(context, '+91 XXXXX XXXXX'),
                ),
              ),
              const SizedBox(height: 10),
              if (_sent)
                _Field(
                  label: 'OTP',
                  child: TextField(
                    controller: _otp,
                    keyboardType: TextInputType.number,
                    decoration: _input(context, 'Enter OTP'),
                  ),
                ),

              const Spacer(),

              if (!_sent)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NiraiTheme.accent,
                      foregroundColor: NiraiTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
                      ),
                    ),
                    onPressed: () => setState(() => _sent = true),
                    child: Text('Send OTP', style: text.labelLarge),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NiraiTheme.accent,
                      foregroundColor: NiraiTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
                      ),
                    ),
                    onPressed: () {
                      state.login(phoneNumber: _phone.text.trim());
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(builder: (_) => const VendorShell()),
                      );
                    },
                    child: Text('Verify & Continue', style: text.labelLarge),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration _input(BuildContext context, String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.55)),
    filled: true,
    fillColor: NiraiTheme.background,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
      borderSide: BorderSide(color: NiraiTheme.primary.withOpacity(0.14)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
      borderSide: const BorderSide(color: NiraiTheme.primary, width: 1.2),
    ),
  );
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72))),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
