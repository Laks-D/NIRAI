import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../app/app_state.dart';
import '../widgets/quiet_card.dart';
import 'request_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final state = AppStateScope.of(context);
    final history = state.history;

    return Scaffold(
      backgroundColor: NiraiTheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
          children: [
            Text('History', style: text.displaySmall),
            const SizedBox(height: 10),
            Text(
              'Past Silent Bells and deals (mock).',
              style: text.bodyLarge?.copyWith(color: NiraiTheme.primary.withOpacity(0.75)),
            ),
            const SizedBox(height: 16),

            if (history.isEmpty)
              QuietCard(
                child: Text(
                  'No requests yet. Try “Silent Bell” from a vendor card.',
                  style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.75)),
                ),
              )
            else
              ...history.map(
                (r) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: QuietCard(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => RequestDetailScreen(requestId: r.id),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.vendorName, style: text.titleMedium),
                        const SizedBox(height: 6),
                        Text(
                          '${r.typeLabel} · ${r.timeWindowLabel}',
                          style: text.bodySmall?.copyWith(color: NiraiTheme.primary.withOpacity(0.75)),
                        ),
                        if (r.note.trim().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            r.note,
                            style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.85)),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          'Status: ${_statusLabel(r.status)}',
                          style: text.bodySmall?.copyWith(color: NiraiTheme.primary.withOpacity(0.75)),
                        ),
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

  static String _statusLabel(RequestStatus status) {
    switch (status) {
      case RequestStatus.sent:
        return 'Sent';
      case RequestStatus.seen:
        return 'Seen';
      case RequestStatus.accepted:
        return 'Accepted';
      case RequestStatus.arriving:
        return 'Arriving';
      case RequestStatus.completed:
        return 'Completed';
    }
  }
}
