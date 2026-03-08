import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Container(
          decoration: BoxDecoration(
            color: NiraiTheme.background,
            borderRadius: BorderRadius.circular(NiraiTheme.radiusCard),
            border: Border.all(color: NiraiTheme.primary.withOpacity(0.16)),
            boxShadow: NiraiTheme.cardShadow(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.wifi_off_rounded, color: NiraiTheme.primary.withOpacity(0.9)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'You’re offline. Showing cached results.',
                  style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.85)),
                ),
              ),
              TextButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
