import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../app/app_state.dart';
import '../widgets/quiet_card.dart';

class GoLiveScreen extends StatelessWidget {
  const GoLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final text = Theme.of(context).textTheme;
    final profile = state.profile;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(profile?.name ?? 'Vendor', style: text.headlineLarge),
            const SizedBox(height: 6),
            Text(
              'Status, health, and current hex.',
              style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72)),
            ),
            const SizedBox(height: 16),

            QuietCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Go Live', style: text.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _StatusChip(
                        label: 'Off-duty',
                        selected: state.availability == VendorAvailability.offDuty,
                        onTap: () => state.setAvailability(VendorAvailability.offDuty),
                      ),
                      _StatusChip(
                        label: 'Paused',
                        selected: state.availability == VendorAvailability.paused,
                        onTap: () => state.setAvailability(VendorAvailability.paused),
                      ),
                      _StatusChip(
                        label: 'Active',
                        selected: state.availability == VendorAvailability.active,
                        onTap: () => state.setAvailability(VendorAvailability.active),
                        highlight: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            QuietCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Health', style: text.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _HealthPill(
                        icon: Icons.battery_full,
                        label: '${(state.batteryLevel * 100).round()}%',
                      ),
                      const SizedBox(width: 10),
                      _HealthPill(
                        icon: state.networkOnline ? Icons.wifi : Icons.wifi_off,
                        label: state.networkOnline ? 'Online' : 'Offline',
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoRow(
                          icon: Icons.my_location,
                          label: 'Last GPS ping',
                          value: _formatAgo(state.lastGpsPing),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoRow(
                          icon: Icons.hexagon_outlined,
                          label: 'Current H3',
                          value: state.currentH3Cell,
                          mono: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NiraiTheme.accent,
                        foregroundColor: NiraiTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
                        ),
                      ),
                      onPressed: state.pingNow,
                      child: Text('Ping now', style: text.labelLarge),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.highlight = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? (highlight ? NiraiTheme.accent : NiraiTheme.primary.withOpacity(0.10)) : NiraiTheme.background;
    final border = selected ? Colors.transparent : NiraiTheme.primary.withOpacity(0.18);
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
      child: InkWell(
        borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
        onTap: onTap,
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
            border: Border.all(color: border),
          ),
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    );
  }
}

class _HealthPill extends StatelessWidget {
  const _HealthPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: NiraiTheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
        border: Border.all(color: NiraiTheme.primary.withOpacity(0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: NiraiTheme.primary),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value, this.mono = false});

  final IconData icon;
  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: NiraiTheme.primary.withOpacity(0.85)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72))),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: mono
                    ? text.bodyMedium?.copyWith(fontFamily: 'monospace', color: NiraiTheme.primary)
                    : text.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _formatAgo(DateTime? time) {
  if (time == null) return '—';
  final diff = DateTime.now().difference(time);
  if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  return '${diff.inHours}h ago';
}
