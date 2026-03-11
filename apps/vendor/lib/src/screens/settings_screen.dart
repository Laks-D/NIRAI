import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';
import 'package:nirai_shared/portal_scope.dart';

import '../app/app_state.dart';
import '../app/app_persistence_scope.dart';
import '../widgets/quiet_card.dart';
import '../app/app_shell.dart';
import 'tracking_settings_screen.dart';
import 'vendor_profile_screen.dart';
import 'v1_placeholder_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final text = Theme.of(context).textTheme;
    final profile = state.profile;
    final portal = PortalScope.maybeOf(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: ListView(
          children: [
            Text('Settings', style: text.headlineLarge),
            const SizedBox(height: 6),
            Text(
              '${profile?.category ?? 'Vendor'} · ${profile?.cartType ?? '—'}',
              style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72)),
            ),
            const SizedBox(height: 16),

            QuietCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('MVP', style: text.titleMedium),
                  const SizedBox(height: 10),
                  _Row(
                    icon: Icons.track_changes,
                    title: 'Low-power tracking',
                    subtitle: 'Motion sensitivity, GPS cadence, data cap',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const TrackingSettingsScreen()),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _Row(
                    icon: Icons.storefront_outlined,
                    title: 'Vendor profile',
                    subtitle: 'Business info, radius, language',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const VendorProfileScreen()),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            QuietCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('V1+ (wired, placeholders)', style: text.titleMedium),
                  const SizedBox(height: 10),
                  _Row(
                    icon: Icons.inventory_2_outlined,
                    title: 'Inventory / Offerings',
                    subtitle: 'Quick catalog + availability toggles',
                    onTap: () => _openV1(context, 'Inventory / Offerings'),
                  ),
                  const SizedBox(height: 10),
                  _Row(
                    icon: Icons.handshake_outlined,
                    title: 'Digital bargaining',
                    subtitle: 'Counter-offers and approvals',
                    onTap: () => _openV1(context, 'Digital Bargaining'),
                  ),
                  const SizedBox(height: 10),
                  _Row(
                    icon: Icons.layers_outlined,
                    title: 'Demand heatmap',
                    subtitle: 'H3 overlays and density',
                    onTap: () => _openV1(context, 'Demand Heatmap'),
                  ),
                  const SizedBox(height: 10),
                  _Row(
                    icon: Icons.alt_route,
                    title: 'Route optimization',
                    subtitle: 'Suggested path + skip stop',
                    onTap: () => _openV1(context, 'Route Optimization'),
                  ),
                  const SizedBox(height: 10),
                  _Row(
                    icon: Icons.payments_outlined,
                    title: 'Earnings dashboard',
                    subtitle: 'Daily totals and trends',
                    onTap: () => _openV1(context, 'Earnings Dashboard'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            if (portal != null) ...[
              QuietCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Portal', style: text.titleMedium),
                    const SizedBox(height: 10),
                    _Row(
                      icon: Icons.swap_horiz_rounded,
                      title: 'Switch to Client',
                      subtitle: 'Go to consumer portal UI',
                      onTap: () => portal.setRole(PortalRole.client),
                    ),
                    const SizedBox(height: 10),
                    _Row(
                      icon: Icons.star_border_rounded,
                      title: 'Set Client as default',
                      subtitle: 'Default portal when opening Nirai',
                      onTap: () => portal.setDefaultRole(PortalRole.client),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
            QuietCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account', style: text.titleMedium),
                  const SizedBox(height: 10),
                  _Row(
                    icon: Icons.logout,
                    title: 'Logout',
                    subtitle: 'Remove session from this device',
                    onTap: () {
                      AppPersistenceScope.maybeOf(context)?.clearAuth();
                      state.logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute<void>(builder: (_) => const AppShell()),
                        (r) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openV1(BuildContext context, String title) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => V1PlaceholderScreen(title: title)));
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(NiraiTheme.radiusCard),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: NiraiTheme.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
              ),
              child: Icon(icon, color: NiraiTheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: text.bodyLarge),
                  const SizedBox(height: 2),
                  Text(subtitle, style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72))),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: NiraiTheme.primary.withOpacity(0.65)),
          ],
        ),
      ),
    );
  }
}
