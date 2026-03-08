import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../app/app_state.dart';
import '../widgets/quiet_card.dart';

class TrackingSettingsScreen extends StatefulWidget {
  const TrackingSettingsScreen({super.key});

  @override
  State<TrackingSettingsScreen> createState() => _TrackingSettingsScreenState();
}

class _TrackingSettingsScreenState extends State<TrackingSettingsScreen> {
  late TrackingSettings _settings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = AppStateScope.of(context);
    _settings = TrackingSettings(
      motionSensitivity: state.tracking.motionSensitivity,
      gpsCadenceSecondsMoving: state.tracking.gpsCadenceSecondsMoving,
      dataCapMbPerDay: state.tracking.dataCapMbPerDay,
      fallbackMode: state.tracking.fallbackMode,
    );
  }

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
        title: Text('Low-power tracking', style: text.titleMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: Column(
          children: [
            QuietCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Motion sensitivity', style: text.titleMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: MotionSensitivity.values
                        .map((m) => _Pill(
                              label: _label(m),
                              selected: _settings.motionSensitivity == m,
                              onTap: () => setState(() => _settings.motionSensitivity = m),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            QuietCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('GPS cadence (moving)', style: text.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    '${_settings.gpsCadenceSecondsMoving}s',
                    style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72)),
                  ),
                  Slider(
                    value: _settings.gpsCadenceSecondsMoving.toDouble(),
                    min: 5,
                    max: 60,
                    divisions: 11,
                    onChanged: (v) => setState(() => _settings.gpsCadenceSecondsMoving = v.round()),
                    activeColor: NiraiTheme.primary,
                    inactiveColor: NiraiTheme.primary.withOpacity(0.15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            QuietCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data cap', style: text.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    '${_settings.dataCapMbPerDay} MB/day',
                    style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72)),
                  ),
                  Slider(
                    value: _settings.dataCapMbPerDay.toDouble(),
                    min: 50,
                    max: 500,
                    divisions: 9,
                    onChanged: (v) => setState(() => _settings.dataCapMbPerDay = v.round()),
                    activeColor: NiraiTheme.primary,
                    inactiveColor: NiraiTheme.primary.withOpacity(0.15),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _settings.fallbackMode,
                    onChanged: (v) => setState(() => _settings.fallbackMode = v),
                    title: Text('Fallback mode', style: text.bodyLarge),
                    subtitle: Text(
                      'Keep working on weak 2G/3G by reducing payloads.',
                      style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72)),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: NiraiTheme.accent,
                  foregroundColor: NiraiTheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(NiraiTheme.radiusPill)),
                ),
                onPressed: () {
                  state.updateTracking(_settings);
                  Navigator.of(context).pop();
                },
                child: Text('Save', style: text.labelLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _label(MotionSensitivity m) {
  switch (m) {
    case MotionSensitivity.low:
      return 'Low';
    case MotionSensitivity.medium:
      return 'Medium';
    case MotionSensitivity.high:
      return 'High';
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? NiraiTheme.accent : NiraiTheme.background;
    final border = selected ? Colors.transparent : NiraiTheme.primary.withOpacity(0.18);
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
        child: Container(
          height: 36,
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
