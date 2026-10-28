import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carvora_provider.dart';
import '../theme/carvora_theme.dart';
import '../widgets/accessory_card.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarvoraProvider>();
    final wishlist = provider.wishlistAccessories;
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 1;
    if (screenWidth > 1100) {
      crossAxisCount = 3;
    } else if (screenWidth > 680) {
      crossAxisCount = 2;
    }

    if (wishlist.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CarvoraColors.surfaceHighlight,
                  border: Border.all(color: CarvoraColors.border),
                ),
                child: const Icon(Icons.favorite_border, size: 48, color: CarvoraColors.gold),
              ),
              const SizedBox(height: 20),
              const Text(
                'YOUR WISHLIST IS EMPTY',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Save your favorite bespoke carbon, titanium, and interior enhancements to review them anytime.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: CarvoraColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => provider.setNavIndex(1),
                child: const Text('DISCOVER ACCESSORIES'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CURATED WISHLIST',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${wishlist.length} saved bespoke enhancements',
                    style: const TextStyle(fontSize: 12, color: CarvoraColors.textSecondary),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () {
                  for (final item in wishlist) {
                    provider.addToCart(item);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: CarvoraColors.surfaceElevated,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: CarvoraColors.gold, width: 0.8),
                      ),
                      content: Text('Added all ${wishlist.length} items to order'),
                      action: SnackBarAction(
                        label: 'VIEW CART',
                        textColor: CarvoraColors.gold,
                        onPressed: () => provider.setNavIndex(3),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart, size: 16),
                label: const Text('ADD ALL TO CART'),
              ),
            ],
          ),
        ),

        // Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: crossAxisCount == 1 ? 0.95 : 0.72,
            ),
            itemCount: wishlist.length,
            itemBuilder: (context, index) {
              final item = wishlist[index];
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
}
