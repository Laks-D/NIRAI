import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../app/app_state.dart';
import '../widgets/quiet_card.dart';
import 'request_detail_screen.dart';

class RequestsInboxScreen extends StatelessWidget {
  const RequestsInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final text = Theme.of(context).textTheme;
    final items = state.requests;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Requests', style: text.headlineLarge),
            const SizedBox(height: 6),
            Text(
              'Silent Bells sorted by proximity/time.',
              style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72)),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final r = items[index];
                  return QuietCard(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => RequestDetailScreen(requestId: r.id)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _StatusDot(status: r.status),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${r.distanceMeters}m · ${_ago(r.createdAt)}',
                                style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72)),
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, color: NiraiTheme.primary.withOpacity(0.65)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.hexagon_outlined, size: 16, color: NiraiTheme.primary.withOpacity(0.85)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(r.customerHex, maxLines: 1, overflow: TextOverflow.ellipsis, style: text.bodyLarge),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          r.items.join(' · '),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.85)),
                        ),
                        if (r.note != null && r.note!.trim().isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            r.note!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72)),
                          ),
                        ],
                        const SizedBox(height: 12),
                        _Actions(request: r),
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

class _Actions extends StatelessWidget {
  const _Actions({required this.request});

  final SilentBellRequest request;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final text = Theme.of(context).textTheme;

    final isTerminal = request.status == RequestStatus.declined || request.status == RequestStatus.fulfilled;
    if (isTerminal) {
      return Row(
        children: [
          Text(
            request.status == RequestStatus.declined ? 'Declined' : 'Fulfilled',
            style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72)),
          ),
          if (request.lastQuickReply != null) ...[
            const SizedBox(width: 10),
            Text('· ${request.lastQuickReply}', style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72))),
          ],
        ],
      );
    }

    if (request.status == RequestStatus.accepted) {
      return Text(
        'Accepted · ETA ${request.etaMinutes ?? 0}m · Tap to update',
        style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.78)),
      );
    }

    if (request.status == RequestStatus.arriving) {
      return Text(
        'Arriving · Tap to complete',
        style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.78)),
      );
    }

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
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});

  final RequestStatus status;

  @override
  Widget build(BuildContext context) {
    Color c;
    switch (status) {
      case RequestStatus.pending:
        c = NiraiTheme.accent;
        break;
      case RequestStatus.accepted:
        c = const Color(0xFF2E8B57);
        break;
      case RequestStatus.arriving:
        c = const Color(0xFF2563EB);
        break;
      case RequestStatus.declined:
        c = const Color(0xFFB22222);
        break;
      case RequestStatus.fulfilled:
        c = NiraiTheme.primary.withOpacity(0.55);
        break;
    }
    return Container(width: 10, height: 10, decoration: BoxDecoration(color: c, shape: BoxShape.circle));
  }
}

String _ago(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return '${diff.inSeconds}s ago';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  return '${diff.inHours}h ago';
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
