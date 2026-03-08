import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../../widgets/vendor_card.dart';
import '../app/app_state.dart';
import 'location_setup_screen.dart';
import 'silent_bell_screen.dart';
import 'vendor_profile_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _searchController = TextEditingController();
  int _categoryIndex = 0;

  static const _categories = ['All', 'Fruits', 'Veggies', 'Flowers'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final state = AppStateScope.of(context);

    final selectedCategory = _categories[_categoryIndex];
    final query = _searchController.text.trim().toLowerCase();

    final filtered = state.vendors.where((v) {
      final categoryOk = selectedCategory == 'All' || v.category == selectedCategory;
      final queryOk = query.isEmpty || v.name.toLowerCase().contains(query);
      return categoryOk && queryOk;
    }).toList(growable: false);

    return Scaffold(
      backgroundColor: NiraiTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: NiraiTheme.background,
            surfaceTintColor: NiraiTheme.background,
            elevation: 0,
            toolbarHeight: 96,
            titleSpacing: 20,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: NiraiTheme.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(state.localityLabel, style: text.bodyLarge, overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const LocationSetupScreen()),
                        );
                      },
                      child: const Text('Switch'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _SearchBar(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fresh and Local', style: text.headlineLarge),
                  const SizedBox(height: 6),
                  Text(
                    'Hyper-local street vendors near you.',
                    style: text.bodyMedium?.copyWith(color: NiraiTheme.primary.withOpacity(0.72)),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final selected = index == _categoryIndex;
                        return _CategoryPill(
                          label: _categories[index],
                          selected: selected,
                          onTap: () => setState(() => _categoryIndex = index),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.78,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final vendor = filtered[index % filtered.length];
                  final data = VendorCardData(
                    name: vendor.name,
                    h3Distance: '${vendor.distanceLabel} away · ${vendor.hexLabel}',
                  );

                  return VendorCard(
                    data: data,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VendorProfileScreen(vendorId: vendor.id),
                        ),
                      );
                    },
                    onAction: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SilentBellScreen(vendorId: vendor.id),
                        ),
                      );
                    },
                  );
                },
                childCount: filtered.isEmpty ? 0 : (filtered.length.clamp(0, 8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: NiraiTheme.background,
        borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
        border: Border.all(color: NiraiTheme.primary.withOpacity(0.14)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(Icons.search, color: NiraiTheme.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Find local produce...',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: NiraiTheme.primary.withOpacity(0.55)),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(NiraiTheme.radiusPill),
              border: Border.all(color: NiraiTheme.primary.withOpacity(0.14)),
            ),
            child: const Icon(Icons.tune, color: NiraiTheme.primary, size: 18),
          ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

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
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
