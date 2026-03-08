import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../app/app_state.dart';
import '../widgets/quiet_card.dart';
import 'silent_bell_screen.dart';
import 'vendor_profile_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final state = AppStateScope.of(context);

    final favs = state.vendors.where((v) => state.favoriteVendorIds.contains(v.id)).toList();
    final nearbyNow = favs.where((v) => v.isActive).toList();

    return Scaffold(
      backgroundColor: NiraiTheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
          children: [
            Text('Favorites', style: text.displaySmall),
            const SizedBox(height: 10),
            Text(
              'Saved vendors with a quiet “nearby now” view.',
              style: text.bodyLarge?.copyWith(color: NiraiTheme.primary.withOpacity(0.75)),
            ),
            const SizedBox(height: 16),

            if (nearbyNow.isNotEmpty) ...[
              Text('Nearby now', style: text.titleMedium),
              const SizedBox(height: 10),
              ...nearbyNow.map(
                (v) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: QuietCard(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => VendorProfileScreen(vendorId: v.id)),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.favorite, color: NiraiTheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(v.name, style: text.titleMedium),
                              const SizedBox(height: 4),
                              Text(
                                '${v.distanceLabel} away · ${v.hexLabel}',
                                style: text.bodySmall?.copyWith(color: NiraiTheme.primary.withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => SilentBellScreen(vendorId: v.id)),
                            );
                          },
                          child: const Text('Silent Bell'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            Text('All favorites', style: text.titleMedium),
            const SizedBox(height: 10),
            if (favs.isEmpty)
              QuietCard(
                child: Text(
                  'No favorites yet.',
                  style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.75)),
                ),
              )
            else
              ...favs.map(
                (v) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: QuietCard(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => VendorProfileScreen(vendorId: v.id)),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          v.isActive ? Icons.circle : Icons.circle_outlined,
                          size: 12,
                          color: v.isActive ? NiraiTheme.accent : NiraiTheme.primary.withOpacity(0.5),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(v.name, style: text.titleMedium)),
                        Icon(Icons.chevron_right, color: NiraiTheme.primary.withOpacity(0.7)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
