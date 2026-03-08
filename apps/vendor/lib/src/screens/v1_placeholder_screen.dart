import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

class V1PlaceholderScreen extends StatelessWidget {
  const V1PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: NiraiTheme.background,
      appBar: AppBar(
        backgroundColor: NiraiTheme.background,
        surfaceTintColor: NiraiTheme.background,
        elevation: 0,
        title: Text(title, style: text.titleMedium),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Coming soon.',
            style: text.headlineMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
