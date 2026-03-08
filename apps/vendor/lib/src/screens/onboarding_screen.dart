import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../app/app_state.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _name = TextEditingController();
  String _category = 'Fruits';
  String _cartType = 'Push cart';

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final state = AppStateScope.of(context);

    return Scaffold(
      backgroundColor: NiraiTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Battery-first tracking', style: text.headlineLarge),
              const SizedBox(height: 10),
              _Bullet(
                title: 'Motion-gated GPS',
                body: 'GPS updates only when your phone detects movement.',
              ),
              _Bullet(
                title: 'Low data signaling',
                body: 'Silent Bells arrive without heavy polling.',
              ),
              const SizedBox(height: 16),

              Text('Basic profile', style: text.headlineMedium),
              const SizedBox(height: 12),
              _Field(label: 'Vendor name', child: TextField(controller: _name, decoration: _input('e.g., Anjali Fruit Cart'))),
              const SizedBox(height: 10),
              _Field(
                label: 'Category',
                child: _Dropdown(
                  value: _category,
                  items: const ['Fruits', 'Veggies', 'Flowers', 'Snacks'],
                  onChanged: (v) => setState(() => _category = v),
                ),
              ),
              const SizedBox(height: 10),
              _Field(
                label: 'Cart type',
                child: _Dropdown(
                  value: _cartType,
                  items: const ['Push cart', 'Bicycle', 'Hand basket', 'Mini truck'],
                  onChanged: (v) => setState(() => _cartType = v),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
                    ),
                  ),
                  onPressed: () {
                    final name = _name.text.trim().isEmpty ? 'Nirai Vendor' : _name.text.trim();
                    state.completeOnboarding(VendorProfile(name: name, category: _category, cartType: _cartType));
                    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => const AuthScreen()));
                  },
                  child: Text('Continue', style: text.labelLarge),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _input(String hint) {
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
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 7),
            decoration: const BoxDecoration(color: NiraiTheme.accent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleMedium),
                const SizedBox(height: 2),
                Text(body, style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.78))),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
