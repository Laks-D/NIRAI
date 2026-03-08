import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

class QuietCard extends StatelessWidget {
  const QuietCard({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: NiraiTheme.background,
        borderRadius: BorderRadius.circular(NiraiTheme.radiusCard),
        border: Border.all(color: NiraiTheme.primary.withOpacity(0.10)),
        boxShadow: NiraiTheme.cardShadow(),
      ),
      padding: const EdgeInsets.all(14),
      child: child,
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(NiraiTheme.radiusCard),
        onTap: onTap,
        child: card,
      ),
    );
  }
}
