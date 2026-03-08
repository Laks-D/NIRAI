import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../app/app_state.dart';
import '../widgets/quiet_card.dart';
import 'silent_bell_screen.dart';

class RequestDetailScreen extends StatelessWidget {
  const RequestDetailScreen({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final state = AppStateScope.of(context);
    final request = state.history.where((r) => r.id == requestId).cast<SilentBellRequest?>().firstWhere(
          (r) => r != null,
          orElse: () => null,
        );

    if (request == null) {
      return Scaffold(
        backgroundColor: NiraiTheme.background,
        appBar: AppBar(
          backgroundColor: NiraiTheme.background,
          surfaceTintColor: NiraiTheme.background,
          elevation: 0,
          title: const Text('Request'),
        ),
        body: const Center(child: Text('Request not found')),
      );
    }

    return Scaffold(
      backgroundColor: NiraiTheme.background,
      appBar: AppBar(
        backgroundColor: NiraiTheme.background,
        surfaceTintColor: NiraiTheme.background,
        elevation: 0,
        title: const Text('Request status'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        children: [
          Text(request.vendorName, style: text.headlineLarge),
          const SizedBox(height: 8),
          Text(
            '${request.typeLabel} · ${request.timeWindowLabel}',
            style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.75)),
          ),
          if (request.note.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(request.note, style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.9))),
          ],
          const SizedBox(height: 16),

          Text('Timeline', style: text.titleMedium),
          const SizedBox(height: 10),
          QuietCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimelineRow(label: 'Sent', done: true),
                const SizedBox(height: 10),
                _TimelineRow(label: 'Seen', done: request.status.index >= RequestStatus.seen.index),
                const SizedBox(height: 10),
                _TimelineRow(label: 'Accepted', done: request.status.index >= RequestStatus.accepted.index),
                const SizedBox(height: 10),
                _TimelineRow(label: 'Arriving', done: request.status.index >= RequestStatus.arriving.index),
              ],
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
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
                    builder: (_) => SilentBellScreen(
                      vendorId: request.vendorId,
                      presetType: request.typeLabel,
                      presetNote: request.note,
                      presetTimeWindow: request.timeWindowLabel,
                    ),
                  ),
                );
              },
              child: const Text('Repeat request'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.label, required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final color = done ? NiraiTheme.primary : NiraiTheme.primary.withOpacity(0.55);
    return Row(
      children: [
        Icon(done ? Icons.check_circle : Icons.radio_button_unchecked, size: 18, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
