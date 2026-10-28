import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carvora_provider.dart';
import '../theme/carvora_theme.dart';
import '../widgets/hero_banner.dart';
import '../widgets/category_chips.dart';
import '../widgets/accessory_card.dart';
import 'product_detail_screen.dart';

class ShowcaseScreen extends StatelessWidget {
  const ShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarvoraProvider>();
    final items = provider.filteredAccessories;
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 1;
    if (screenWidth > 1100) {
      crossAxisCount = 3;
    } else if (screenWidth > 680) {
      crossAxisCount = 2;
    }

    return CustomScrollView(
      slivers: [
        // Hero Section
        SliverToBoxAdapter(
          child: HeroBanner(
            onExploreTap: () => provider.setNavIndex(1),
            onBookConsultationTap: () => provider.setNavIndex(4),
          ),
        ),

        // Value Proposition Pillars
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: CarvoraColors.surfaceHighlight.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: CarvoraColors.border),
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                spacing: 16,
                runSpacing: 10,
                children: const [
                  _PillarItem(icon: Icons.shield_outlined, text: 'Grade 5 Aerospace Alloys'),
                  _PillarItem(icon: Icons.auto_awesome_outlined, text: 'Autoclave Cured Carbon'),
                  _PillarItem(icon: Icons.flight_takeoff_outlined, text: 'Insured Global Transit'),
                ],
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 14)),

        // Category Filter Chips
        const SliverToBoxAdapter(
          child: CategoryChips(),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 18)),

        // Section Heading
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: CarvoraColors.gold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      provider.selectedCategory == 'All'
                          ? 'CURATED MASTERPIECES'
                          : provider.selectedCategory.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${items.length} items',
                  style: const TextStyle(
                    fontSize: 12,
                    color: CarvoraColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Accessories Grid
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: items.isEmpty
              ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        'No accessories found in this collection.',
                        style: TextStyle(color: CarvoraColors.textSecondary),
                      ),
                    ),
                  ),
                )
              : SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: crossAxisCount == 1 ? 0.95 : 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = items[index];
                      return AccessoryCard(
                        accessory: item,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(accessory: item),
                            ),
                          );
                        },
                      );
                    },
                    childCount: items.length,
                  ),
                ),
        ),

        // Bespoke Consultation Footer Banner
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1E2638),
                    Color(0xFF10141D),
                  ],
                ),
                border: Border.all(color: CarvoraColors.borderHighlight.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.handyman_outlined, color: CarvoraColors.gold, size: 36),
                  const SizedBox(height: 12),
                  const Text(
                    'LOOKING FOR BESPOKE COMMISSION?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Our master artisans specialize in 1-of-1 tailored carbon aerodynamic packages, custom titanium exhaust tuning, and starlight roof retrofits.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: CarvoraColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.setNavIndex(4),
                    child: const Text('SCHEDULE VIP CONSULTATION'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PillarItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PillarItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: CarvoraColors.gold),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: CarvoraColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
