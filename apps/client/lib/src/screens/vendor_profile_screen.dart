import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../app/app_state.dart';
import '../widgets/quiet_card.dart';
import 'silent_bell_screen.dart';
import 'v1_placeholder_screen.dart';

class VendorProfileScreen extends StatelessWidget {
  const VendorProfileScreen({super.key, required this.vendorId});

  final String vendorId;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final state = AppStateScope.of(context);
    final vendor = state.vendorById(vendorId);

    if (vendor == null) {
      return Scaffold(
        backgroundColor: NiraiTheme.background,
        appBar: AppBar(
          backgroundColor: NiraiTheme.background,
          surfaceTintColor: NiraiTheme.background,
          elevation: 0,
          title: const Text('Vendor'),
        ),
        body: const Center(child: Text('Vendor not found')),
      );
    }

    final isFav = state.favoriteVendorIds.contains(vendor.id);

    return Scaffold(
      backgroundColor: NiraiTheme.background,
      appBar: AppBar(
        backgroundColor: NiraiTheme.background,
        surfaceTintColor: NiraiTheme.background,
        elevation: 0,
        title: Text(vendor.name),
        actions: [
          IconButton(
            onPressed: () => state.toggleFavorite(vendor.id),
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        children: [
          Text(vendor.category, style: text.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              _Pill(label: vendor.isActive ? 'Active' : 'Offline'),
              const SizedBox(width: 10),
              _Pill(label: '${vendor.distanceLabel} away · ${vendor.hexLabel}'),
              if (vendor.supportsBargaining) ...[
                const SizedBox(width: 10),
                const _Pill(label: 'Bargaining'),
              ],
            ],
          ),
          const SizedBox(height: 14),

          QuietCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Typical inventory', style: text.titleMedium),
                const SizedBox(height: 6),
                Text(
                  'Seasonal produce, daily staples, and quick bundles.',
                  style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.78)),
                ),
                const SizedBox(height: 12),
                Text('Reliability', style: text.titleMedium),
                const SizedBox(height: 6),
                Text(
                  'Last seen recently (mock).',
                  style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.78)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: NiraiTheme.accent,
                      foregroundColor: NiraiTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SilentBellScreen(vendorId: vendor.id),
                        ),
                      );
                    },
                    child: const Text('Silent Bell'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: NiraiTheme.primary,
                      side: BorderSide(color: NiraiTheme.primary.withOpacity(0.18)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const V1PlaceholderScreen(title: 'Start Bargain'),
                        ),
                      );
                    },
                    child: const Text('Start Bargain'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
        border: Border.all(color: NiraiTheme.primary.withOpacity(0.16)),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
