import 'package:flutter/material.dart';
import 'package:nirai_shared/nirai_theme.dart';

import '../widgets/floating_dock.dart';
import '../widgets/vendor_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  int _dockIndex = 0;
  int _categoryIndex = 0;

  static const _categories = ['All', 'Fruits', 'Veggies', 'Flowers'];

  final _vendors = const [
    VendorCardData(
      name: 'Anjali Fruit Cart',
      h3Distance: '150m away · Hexagon Res-7',
    ),
    VendorCardData(
      name: 'Murugan Veggie Stand',
      h3Distance: '280m away · Hexagon Res-7',
    ),
    VendorCardData(
      name: 'Kaveri Flower Shop',
      h3Distance: '90m away · Hexagon Res-7',
    ),
    VendorCardData(
      name: 'Selvi Greens',
      h3Distance: '410m away · Hexagon Res-7',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: NiraiTheme.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: NiraiTheme.background,
                surfaceTintColor: NiraiTheme.background,
                elevation: 0,
                toolbarHeight: 90,
                titleSpacing: 20,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: NiraiTheme.primary),
                        const SizedBox(width: 6),
                        Text('Kotturpuram, Chennai', style: text.bodyLarge),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _SearchBar(controller: _searchController),
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
                      final item = _vendors[index % _vendors.length];
                      return VendorCard(
                        data: item,
                        onAction: () {},
                      );
                    },
                    childCount: 8,
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: SafeArea(
              top: false,
              child: Center(
                child: FloatingDock(
                  index: _dockIndex,
                  onChange: (i) => setState(() => _dockIndex = i),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});

  final TextEditingController controller;

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
