import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

class QuietCard extends StatelessWidget {
  const QuietCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: NiraiTheme.background,
        borderRadius: BorderRadius.circular(NiraiTheme.radiusCard),
        border: Border.all(color: NiraiTheme.primary.withOpacity(0.10)),
        boxShadow: NiraiTheme.cardShadow(),
      ),
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
