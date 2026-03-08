import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../app/app_state.dart';
import '../widgets/quiet_card.dart';

class LocationSetupScreen extends StatelessWidget {
  const LocationSetupScreen({super.key});

  static const _localities = <({String name, String hex})>[
    (name: 'Kotturpuram, Chennai', hex: 'Hex Res-7'),
    (name: 'Adyar, Chennai', hex: 'Hex Res-7'),
    (name: 'Alwarpet, Chennai', hex: 'Hex Res-7'),
    (name: 'Mylapore, Chennai', hex: 'Hex Res-7'),
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final state = AppStateScope.of(context);

    return Scaffold(
      backgroundColor: NiraiTheme.background,
      appBar: AppBar(
        backgroundColor: NiraiTheme.background,
        surfaceTintColor: NiraiTheme.background,
        elevation: 0,
        title: const Text('Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pick your area', style: text.headlineLarge),
            const SizedBox(height: 8),
            Text(
              'We display coarse H3-style hexes for privacy.',
              style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.75)),
            ),
            const SizedBox(height: 16),

            QuietCard(
              onTap: () {
                state.setLocality(locality: state.localityLabel, hex: state.hexLabel);
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  const Icon(Icons.my_location, color: NiraiTheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Use current location (mock)', style: text.titleMedium),
                  ),
                  Icon(Icons.chevron_right, color: NiraiTheme.primary.withOpacity(0.7)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                itemCount: _localities.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _localities[index];
                  return QuietCard(
                    onTap: () {
                      state.setLocality(locality: item.name, hex: item.hex);
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: NiraiTheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: text.titleMedium),
                              const SizedBox(height: 4),
                              Text(
                                item.hex,
                                style: text.bodySmall?.copyWith(
                                  color: NiraiTheme.primary.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: NiraiTheme.primary.withOpacity(0.7)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
