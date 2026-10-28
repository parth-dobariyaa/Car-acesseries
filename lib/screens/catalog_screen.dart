import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/accessory.dart';
import '../providers/carvora_provider.dart';
import '../theme/carvora_theme.dart';
import '../widgets/category_chips.dart';
import '../widgets/accessory_card.dart';
import 'product_detail_screen.dart';

enum SortOption { featured, priceAsc, priceDesc, rating }

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  SortOption _currentSort = SortOption.featured;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarvoraProvider>();
    List<Accessory> items = List.from(provider.filteredAccessories);

    // Apply sorting
    switch (_currentSort) {
      case SortOption.priceAsc:
        items.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        items.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.rating:
        items.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.featured:
        items.sort((a, b) => (b.isFeatured ? 1 : 0).compareTo(a.isFeatured ? 1 : 0));
        break;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    if (screenWidth > 1100) {
      crossAxisCount = 3;
    } else if (screenWidth > 680) {
      crossAxisCount = 2;
    }

    return Column(
      children: [
        // Search & Filter Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => provider.setSearchQuery(val),
                  decoration: InputDecoration(
                    hintText: 'Search titanium, carbon, aero, wheels...',
                    prefixIcon: const Icon(Icons.search, color: CarvoraColors.gold),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              provider.setSearchQuery('');
                            },
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              PopupMenuButton<SortOption>(
                color: CarvoraColors.surfaceElevated,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: CarvoraColors.border),
                ),
                icon: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CarvoraColors.surfaceHighlight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CarvoraColors.border),
                  ),
                  child: const Icon(Icons.sort, color: CarvoraColors.gold, size: 20),
                ),
                onSelected: (sort) => setState(() => _currentSort = sort),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: SortOption.featured,
                    child: Text('Featured First', style: TextStyle(fontSize: 13)),
                  ),
                  const PopupMenuItem(
                    value: SortOption.rating,
                    child: Text('Highest Rated', style: TextStyle(fontSize: 13)),
                  ),
                  const PopupMenuItem(
                    value: SortOption.priceAsc,
                    child: Text('Price: Low to High', style: TextStyle(fontSize: 13)),
                  ),
                  const PopupMenuItem(
                    value: SortOption.priceDesc,
                    child: Text('Price: High to Low', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Category Chips
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: CategoryChips(),
        ),

        // Results Summary
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Showing ${items.length} enhancements',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: CarvoraColors.textSecondary,
                ),
              ),
              if (_currentSort != SortOption.featured)
                Text(
                  'Sorted: ${_sortLabel(_currentSort)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: CarvoraColors.gold,
                  ),
                ),
            ],
          ),
        ),

        // Grid
        Expanded(
          child: items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off, size: 48, color: CarvoraColors.textMuted),
                      const SizedBox(height: 12),
                      const Text(
                        'No matching accessories found',
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Try searching for other keywords or reset filters.',
                        style: TextStyle(fontSize: 13, color: CarvoraColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          _searchController.clear();
                          provider.setSearchQuery('');
                          provider.setSelectedCategory('All');
                        },
                        child: const Text('Reset All Filters', style: TextStyle(color: CarvoraColors.gold)),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: crossAxisCount == 1 ? 0.95 : 0.72,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
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
                ),
        ),
      ],
    );
  }

  String _sortLabel(SortOption sort) {
    switch (sort) {
      case SortOption.priceAsc:
        return 'Price: Low';
      case SortOption.priceDesc:
        return 'Price: High';
      case SortOption.rating:
        return 'Rating';
      case SortOption.featured:
        return 'Featured';
    }
  }
}
