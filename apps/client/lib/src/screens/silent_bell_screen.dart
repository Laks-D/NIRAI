import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../app/app_state.dart';
import '../widgets/quiet_card.dart';
import 'request_detail_screen.dart';

class SilentBellScreen extends StatefulWidget {
  const SilentBellScreen({
    super.key,
    required this.vendorId,
    this.presetType,
    this.presetNote,
    this.presetTimeWindow,
  });

  final String vendorId;
  final String? presetType;
  final String? presetNote;
  final String? presetTimeWindow;

  @override
  State<SilentBellScreen> createState() => _SilentBellScreenState();
}

class _SilentBellScreenState extends State<SilentBellScreen> {
  final _noteController = TextEditingController();

  late String _type;
  late String _timeWindow;
  String? _requestId;

  @override
  void initState() {
    super.initState();
    _type = widget.presetType ?? 'Stop by';
    _timeWindow = widget.presetTimeWindow ?? 'In 15–30 min';
    _noteController.text = widget.presetNote ?? '';
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final state = AppStateScope.of(context);
    final vendor = state.vendorById(widget.vendorId);

    return Scaffold(
      backgroundColor: NiraiTheme.background,
      appBar: AppBar(
        backgroundColor: NiraiTheme.background,
        surfaceTintColor: NiraiTheme.background,
        elevation: 0,
        title: const Text('Silent Bell'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        children: [
          Text(vendor?.name ?? 'Vendor', style: text.headlineLarge),
          const SizedBox(height: 6),
          Text(
            'Send a quiet request—low bandwidth, low noise.',
            style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.75)),
          ),
          const SizedBox(height: 16),

          QuietCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Request type', style: text.titleMedium),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _ChoicePill(
                      label: 'Stop by',
                      selected: _type == 'Stop by',
                      onTap: () => setState(() => _type = 'Stop by'),
                    ),
                    _ChoicePill(
                      label: 'Specific items',
                      selected: _type == 'Specific items',
                      onTap: () => setState(() => _type = 'Specific items'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text('Note (optional)', style: text.titleMedium),
                const SizedBox(height: 10),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Tomatoes, coriander, and 6 bananas',
                  ),
                ),
                const SizedBox(height: 14),
                Text('Preferred time window', style: text.titleMedium),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _timeWindow,
                  items: const [
                    DropdownMenuItem(value: 'Now', child: Text('Now')),
                    DropdownMenuItem(value: 'In 15–30 min', child: Text('In 15–30 min')),
                    DropdownMenuItem(value: 'In 45–60 min', child: Text('In 45–60 min')),
                  ],
                  onChanged: (v) => setState(() => _timeWindow = v ?? _timeWindow),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: NiraiTheme.accent,
                foregroundColor: NiraiTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
                ),
              ),
              onPressed: _requestId == null
                  ? () {
                      final request = state.createSilentBell(
                        vendorId: widget.vendorId,
                        typeLabel: _type,
                        note: _noteController.text.trim(),
                        timeWindowLabel: _timeWindow,
                      );
                      setState(() => _requestId = request.id);

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => RequestDetailScreen(requestId: request.id),
                        ),
                      );
                    }
                  : null,
              child: Text(_requestId == null ? 'Send request' : 'Request sent'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? NiraiTheme.accent : NiraiTheme.background,
      borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
            border: Border.all(
              color: selected ? Colors.transparent : NiraiTheme.primary.withOpacity(0.18),
            ),
          ),
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    );
  }
}

