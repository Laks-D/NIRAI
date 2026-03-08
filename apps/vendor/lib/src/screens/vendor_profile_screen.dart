import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../app/app_state.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  final _name = TextEditingController();
  final _radius = TextEditingController();
  String _language = 'English';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = AppStateScope.of(context);
    final p = state.profile;
    _name.text = p?.name ?? '';
    _radius.text = (p?.serviceRadiusKm ?? 1.5).toStringAsFixed(1);
    _language = p?.language ?? 'English';
  }

  @override
  void dispose() {
    _name.dispose();
    _radius.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final text = Theme.of(context).textTheme;
    final p = state.profile;

    return Scaffold(
      backgroundColor: NiraiTheme.background,
      appBar: AppBar(
        backgroundColor: NiraiTheme.background,
        surfaceTintColor: NiraiTheme.background,
        elevation: 0,
        title: Text('Vendor profile', style: text.titleMedium),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            children: [
              _Field(label: 'Business name', child: TextField(controller: _name, decoration: _input(context, 'e.g., Anjali Fruit Cart'))),
              const SizedBox(height: 12),
              _Field(
                label: 'Service radius (km)',
                child: TextField(
                  controller: _radius,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: _input(context, 'e.g., 1.5'),
                ),
              ),
              const SizedBox(height: 12),
              _Field(
                label: 'Language',
                child: _Dropdown(
                  value: _language,
                  items: const ['English', 'தமிழ்', 'हिन्दी'],
                  onChanged: (v) => setState(() => _language = v),
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
                    final next = VendorProfile(
                      name: _name.text.trim().isEmpty ? (p?.name ?? 'Vendor') : _name.text.trim(),
                      category: p?.category ?? 'Fruits',
                      cartType: p?.cartType ?? 'Push cart',
                      serviceRadiusKm: double.tryParse(_radius.text.trim()) ?? (p?.serviceRadiusKm ?? 1.5),
                      language: _language,
                    );
                    state.updateProfile(next);
                    Navigator.of(context).pop();
                  },
                  child: Text('Save', style: text.labelLarge),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration _input(BuildContext context, String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.55)),
    filled: true,
    fillColor: NiraiTheme.background,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
      borderSide: BorderSide(color: NiraiTheme.primary.withOpacity(0.14)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
      borderSide: const BorderSide(color: NiraiTheme.primary, width: 1.2),
    ),
  );
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72))),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({required this.value, required this.items, required this.onChanged});

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: NiraiTheme.background,
        borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
        border: Border.all(color: NiraiTheme.primary.withOpacity(0.14)),
      ),
      alignment: Alignment.centerLeft,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: NiraiTheme.primary),
          items: items
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e, style: Theme.of(context).textTheme.bodyLarge),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
