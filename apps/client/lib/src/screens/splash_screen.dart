import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.next});

  final Widget next;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_boot());
  }

  Future<void> _boot() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => widget.next),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: NiraiTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text('Nirai', style: text.displaySmall),
              const SizedBox(height: 10),
              Text(
                'Quiet luxury for hyper-local shopping.',
                style: text.bodyLarge?.copyWith(color: NiraiTheme.primary.withOpacity(0.78)),
              ),
              const SizedBox(height: 18),
              const LinearProgressIndicator(
                minHeight: 2,
                backgroundColor: Color(0x1A2F4F4F),
                color: NiraiTheme.primary,
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
