import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

class VendorCardData {
  const VendorCardData({required this.name, required this.h3Distance});

  final String name;
  final String h3Distance;
}

class VendorCard extends StatelessWidget {
  const VendorCard({
    super.key,
    required this.data,
    required this.onAction,
    this.onTap,
  });

  final VendorCardData data;
  final VoidCallback onAction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(NiraiTheme.radiusCard),
        child: Container(
          decoration: BoxDecoration(
            color: NiraiTheme.background,
            borderRadius: BorderRadius.circular(NiraiTheme.radiusCard),
            border: Border.all(color: NiraiTheme.primary.withOpacity(0.10)),
            boxShadow: NiraiTheme.cardShadow(),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(NiraiTheme.radiusCard - 6),
                        color: NiraiTheme.primary.withOpacity(0.06),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: _YellowActionButton(onTap: onAction),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                data.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.titleMedium,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.hexagon_outlined,
                    size: 14,
                    color: NiraiTheme.primary.withOpacity(0.80),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      data.h3Distance,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodyMedium?.copyWith(
                        color: NiraiTheme.primary.withOpacity(0.85),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _YellowActionButton extends StatelessWidget {
  const _YellowActionButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: NiraiTheme.accent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 34,
          height: 34,
          child: Icon(Icons.flash_on_rounded, color: NiraiTheme.primary, size: 18),
        ),
      ),
    );
  }
}
