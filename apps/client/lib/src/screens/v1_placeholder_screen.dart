import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../widgets/quiet_card.dart';

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
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: QuietCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Coming soon', style: text.headlineLarge),
              const SizedBox(height: 8),
              Text(
                'This is a V1+ placeholder screen in the scaffold.',
                style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.78)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
