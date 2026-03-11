import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';
import 'package:nirai_shared/portal_scope.dart';

import '../app/app_state.dart';
import '../app/app_persistence_scope.dart';
import '../widgets/quiet_card.dart';
import '../app/app_shell.dart';
import 'location_setup_screen.dart';
import 'v1_placeholder_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final state = AppStateScope.of(context);
    final portal = PortalScope.maybeOf(context);

    return Scaffold(
      backgroundColor: NiraiTheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
          children: [
            Text('Settings', style: text.displaySmall),
            const SizedBox(height: 10),
            Text(
              state.isGuest ? 'Guest session' : 'Signed in (mock)',
              style: text.bodyLarge?.copyWith(color: NiraiTheme.primary.withOpacity(0.75)),
            ),
            const SizedBox(height: 16),

            QuietCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Profile', style: text.titleMedium),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.language, color: NiraiTheme.primary),
                      const SizedBox(width: 12),
                      Expanded(child: Text('Language', style: text.bodyMedium)),
                      DropdownButton<String>(
                        value: state.languageLabel,
                        underline: const SizedBox.shrink(),
                        items: const [
                          DropdownMenuItem(value: 'English', child: Text('English')),
                          DropdownMenuItem(value: 'தமிழ்', child: Text('தமிழ்')),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          state.setLanguage(v);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined, color: NiraiTheme.primary),
                      const SizedBox(width: 12),
                      Expanded(child: Text('Locality', style: text.bodyMedium)),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const LocationSetupScreen()),
                          );
                        },
                        child: const Text('Change'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            QuietCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Privacy', style: text.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    'We avoid precise GPS in the UI; we show coarse hex locality instead.',
                    style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.78)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            QuietCard(
              child: Row(
                children: [
                  const Icon(Icons.battery_saver_outlined, color: NiraiTheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Battery/Data saver', style: text.titleMedium),
                        const SizedBox(height: 4),
                        Text(
                          'Reduce refresh and background work.',
                          style: text.bodySmall?.copyWith(color: NiraiTheme.primary.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: state.dataSaverEnabled,
                    onChanged: state.setDataSaver,
                    activeColor: NiraiTheme.accent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            QuietCard(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const V1PlaceholderScreen(title: 'Moving Warehouse Map')),
                );
              },
              child: Row(
                children: [
                  const Icon(Icons.map_outlined, color: NiraiTheme.primary),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Moving Warehouse Map (V1+)', style: text.titleMedium)),
                  Icon(Icons.chevron_right, color: NiraiTheme.primary.withOpacity(0.7)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            QuietCard(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const V1PlaceholderScreen(title: 'Notifications Inbox')),
                );
              },
              child: Row(
                children: [
                  const Icon(Icons.notifications_none, color: NiraiTheme.primary),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Notifications Inbox (V1+)', style: text.titleMedium)),
                  Icon(Icons.chevron_right, color: NiraiTheme.primary.withOpacity(0.7)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            QuietCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Support & legal', style: text.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    'Support and policies are stubs in this scaffold.',
                    style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.78)),
                  ),
                ],
              ),
            ),

            if (portal != null) ...[
              const SizedBox(height: 12),
              QuietCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Portal', style: text.titleMedium),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.swap_horiz_rounded, color: NiraiTheme.primary),
                        const SizedBox(width: 12),
                        Expanded(child: Text('Switch to Vendor', style: text.bodyMedium)),
                        TextButton(
                          onPressed: () => portal.setRole(PortalRole.vendor),
                          child: const Text('Switch'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_border_rounded, color: NiraiTheme.primary),
                        const SizedBox(width: 12),
                        Expanded(child: Text('Set Vendor as default', style: text.bodyMedium)),
                        TextButton(
                          onPressed: () => portal.setDefaultRole(PortalRole.vendor),
                          child: const Text('Set'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: NiraiTheme.primary,
                  side: BorderSide(color: NiraiTheme.primary.withOpacity(0.18)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
                  ),
                ),
                onPressed: () {
                  AppPersistenceScope.maybeOf(context)?.clearAuth();
                  state.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(builder: (_) => const AppShell()),
                    (r) => false,
                  );
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
