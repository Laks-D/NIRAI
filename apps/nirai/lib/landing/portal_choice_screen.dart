import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';
import 'package:nirai_shared/portal_scope.dart';

class PortalChoiceScreen extends StatelessWidget {
  const PortalChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final portal = PortalScope.of(context);

    return Scaffold(
      backgroundColor: NiraiTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Choose portal', style: text.headlineLarge),
              const SizedBox(height: 8),
              Text(
                'Pick how you want to use Nirai right now. You can switch later in Settings.',
                style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72)),
              ),
              const SizedBox(height: 18),
              _ChoiceCard(
                title: 'Client',
                subtitle: 'Find nearby vendors and send a Silent Bell request',
                onTap: () => portal.setRole(PortalRole.client),
              ),
              const SizedBox(height: 12),
              _ChoiceCard(
                title: 'Vendor',
                subtitle: 'Receive requests and manage low-power tracking',
                onTap: () => portal.setRole(PortalRole.vendor),
              ),
              const Spacer(),
              Text(
                'Tip: Set a default portal in Settings → Portal.',
                style: text.bodySmall?.copyWith(color: NiraiTheme.primary.withOpacity(0.72)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({required this.title, required this.subtitle, required this.onTap});

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(NiraiTheme.radiusCard),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: NiraiTheme.background,
          borderRadius: BorderRadius.circular(NiraiTheme.radiusCard),
          border: Border.all(color: NiraiTheme.primary.withOpacity(0.10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: text.titleLarge),
            const SizedBox(height: 6),
            Text(subtitle, style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72))),
          ],
        ),
      ),
    );
  }
}
