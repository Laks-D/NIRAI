import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../app/app_state.dart';
import '../widgets/quiet_card.dart';

class RequestDetailScreen extends StatelessWidget {
  const RequestDetailScreen({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final r = state.getRequestById(requestId);
    final text = Theme.of(context).textTheme;

    if (r == null) {
      return Scaffold(
        backgroundColor: NiraiTheme.background,
        appBar: AppBar(backgroundColor: NiraiTheme.background, surfaceTintColor: NiraiTheme.background),
        body: Center(child: Text('Request not found', style: text.bodyLarge)),
      );
    }

    return Scaffold(
      backgroundColor: NiraiTheme.background,
      appBar: AppBar(
        backgroundColor: NiraiTheme.background,
        surfaceTintColor: NiraiTheme.background,
        elevation: 0,
        title: Text('Request', style: text.titleMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: Column(
          children: [
            QuietCard(
              child: Row(
                children: [
                  _StatusPill(status: r.status, etaMinutes: r.etaMinutes),
                  const Spacer(),
                  Text(
                    '${r.distanceMeters}m',
                    style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            QuietCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer hex', style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72))),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.hexagon_outlined, size: 18, color: NiraiTheme.primary.withOpacity(0.85)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(r.customerHex, style: text.bodyLarge)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Items', style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72))),
                  const SizedBox(height: 6),
                  Text(r.items.join(' · '), style: text.bodyLarge),
                  if (r.note != null && r.note!.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text('Note', style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72))),
                    const SizedBox(height: 6),
                    Text(r.note!, style: text.bodyLarge),
                  ],
                  const SizedBox(height: 12),
                  Text('Requested', style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72))),
                  const SizedBox(height: 6),
                  Text(_ago(r.createdAt), style: text.bodyLarge),
                ],
              ),
            ),
            const SizedBox(height: 14),
            QuietCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Actions', style: text.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    _helperText(r.status),
                    style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72)),
                  ),
                  const SizedBox(height: 12),
                  _ActionButtons(request: r),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.request});

  final SilentBellRequest request;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final text = Theme.of(context).textTheme;

    if (request.status == RequestStatus.declined || request.status == RequestStatus.fulfilled) {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: NiraiTheme.primary,
            side: BorderSide(color: NiraiTheme.primary.withOpacity(0.18)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(NiraiTheme.radiusPill)),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Back to inbox', style: text.labelLarge),
        ),
      );
    }

    if (request.status == RequestStatus.pending) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: NiraiTheme.primary,
                side: BorderSide(color: NiraiTheme.primary.withOpacity(0.18)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(NiraiTheme.radiusPill)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () async {
                final reply = await showModalBottomSheet<String>(
                  context: context,
                  backgroundColor: NiraiTheme.background,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(NiraiTheme.radiusCard)),
                  builder: (_) => _QuickReplySheet(
                    title: 'Decline request',
                    primary: 'Decline',
                    templates: const ['Out of stock', 'Not in this area', 'Busy right now'],
                  ),
                );
                if (reply != null && context.mounted) {
                  state.declineRequest(request.id, quickReply: reply);
                }
              },
              child: Text('Decline', style: text.labelLarge),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: NiraiTheme.accent,
                foregroundColor: NiraiTheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(NiraiTheme.radiusPill)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () async {
                final eta = await showModalBottomSheet<int>(
                  context: context,
                  backgroundColor: NiraiTheme.background,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(NiraiTheme.radiusCard)),
                  builder: (_) => const _EtaSheet(),
                );
                if (eta != null && context.mounted) {
                  state.acceptRequest(request.id, etaMinutes: eta, quickReply: 'On my way');
                }
              },
              child: Text('Accept', style: text.labelLarge),
            ),
          ),
        ],
      );
    }

    if (request.status == RequestStatus.accepted) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: NiraiTheme.primary,
                side: BorderSide(color: NiraiTheme.primary.withOpacity(0.18)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(NiraiTheme.radiusPill)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () => state.markArriving(request.id),
              child: Text('Mark arriving', style: text.labelLarge),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: NiraiTheme.accent,
                foregroundColor: NiraiTheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(NiraiTheme.radiusPill)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () => state.markFulfilled(request.id),
              child: Text('Mark fulfilled', style: text.labelLarge),
            ),
          ),
        ],
      );
    }

    // arriving
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: NiraiTheme.accent,
          foregroundColor: NiraiTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(NiraiTheme.radiusPill)),
        ),
        onPressed: () => state.markFulfilled(request.id),
        child: Text('Mark fulfilled', style: text.labelLarge),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, required this.etaMinutes});

  final RequestStatus status;
  final int? etaMinutes;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    String label;
    Color bg;

    switch (status) {
      case RequestStatus.pending:
        label = 'Pending';
        bg = NiraiTheme.accent;
        break;
      case RequestStatus.accepted:
        label = 'Accepted${etaMinutes != null ? ' · ETA ${etaMinutes}m' : ''}';
        bg = const Color(0xFF2E8B57);
        break;
      case RequestStatus.arriving:
        label = 'Arriving';
        bg = const Color(0xFF2563EB);
        break;
      case RequestStatus.declined:
        label = 'Declined';
        bg = const Color(0xFFB22222);
        break;
      case RequestStatus.fulfilled:
        label = 'Fulfilled';
        bg = NiraiTheme.primary.withOpacity(0.55);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
      ),
      child: Text(
        label,
        style: text.bodyMedium?.copyWith(color: NiraiTheme.primary),
      ),
    );
  }
}

String _helperText(RequestStatus status) {
  switch (status) {
    case RequestStatus.pending:
      return 'Accept with ETA or decline with a quick reply.';
    case RequestStatus.accepted:
      return 'Update the request as you start moving.';
    case RequestStatus.arriving:
      return 'Complete the request once delivered.';
    case RequestStatus.declined:
      return 'This request is closed.';
    case RequestStatus.fulfilled:
      return 'This request is fulfilled.';
  }
}

class _EtaSheet extends StatelessWidget {
  const _EtaSheet();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    const etas = [5, 10, 15, 20, 30];
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Set ETA', style: text.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: etas
                .map((m) => _Pill(
                      label: '$m min',
                      onTap: () => Navigator.of(context).pop(m),
                      filled: true,
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _QuickReplySheet extends StatelessWidget {
  const _QuickReplySheet({required this.title, required this.primary, required this.templates});

  final String title;
  final String primary;
  final List<String> templates;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: text.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: templates
                .map((t) => _Pill(
                      label: t,
                      onTap: () => Navigator.of(context).pop(t),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: NiraiTheme.accent,
                foregroundColor: NiraiTheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(NiraiTheme.radiusPill)),
              ),
              onPressed: () => Navigator.of(context).pop(templates.first),
              child: Text(primary, style: text.labelLarge),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.onTap, this.filled = false});

  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? NiraiTheme.accent : NiraiTheme.background,
      borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
      child: InkWell(
        borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
        onTap: onTap,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
            border: Border.all(color: NiraiTheme.primary.withOpacity(0.18)),
          ),
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    );
  }
}

String _ago(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return '${diff.inSeconds}s ago';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  return '${diff.inHours}h ago';
}
