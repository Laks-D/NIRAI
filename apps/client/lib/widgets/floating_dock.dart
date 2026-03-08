import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

class FloatingDock extends StatelessWidget {
  const FloatingDock({super.key, required this.index, required this.onChange});

  final int index;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.78,
      height: 62,
      decoration: BoxDecoration(
        color: NiraiTheme.background,
        borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
        border: Border.all(color: NiraiTheme.primary.withOpacity(0.12)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x242F4F4F),
            blurRadius: 18,
            offset: Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _DockItem(
            selected: index == 0,
            icon: Icons.home_outlined,
            onTap: () => onChange(0),
          ),
          _DockItem(
            selected: index == 1,
            icon: Icons.favorite_border,
            onTap: () => onChange(1),
          ),
          _DockItem(
            selected: index == 2,
            icon: Icons.receipt_long_outlined,
            onTap: () => onChange(2),
          ),
          _DockItem(
            selected: index == 3,
            icon: Icons.settings_outlined,
            onTap: () => onChange(3),
          ),
        ],
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  const _DockItem({required this.selected, required this.icon, required this.onTap});

  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            size: 24,
            color: selected ? NiraiTheme.primary : NiraiTheme.primary.withOpacity(0.85),
          ),
        ),
      ),
    );
  }
}
