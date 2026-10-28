import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/accessory.dart';
import '../providers/carvora_provider.dart';
import '../theme/carvora_theme.dart';
import '../utils/currency_formatter.dart';
import '../widgets/accessory_visual.dart';

class ProductDetailScreen extends StatefulWidget {
  final Accessory accessory;

  const ProductDetailScreen({super.key, required this.accessory});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarvoraProvider>();
    final isWishlisted = provider.isWishlisted(widget.accessory.id);
    final a = widget.accessory;

    return Scaffold(
      backgroundColor: CarvoraColors.background,
      appBar: AppBar(
        title: Text(
          a.category.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 2.0,
            color: CarvoraColors.gold,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => provider.toggleWishlist(a.id),
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? Colors.redAccent : Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              provider.setNavIndex(3); // Navigate to cart
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Badge(
              isLabelVisible: provider.cartCount > 0,
              label: Text(
                '${provider.cartCount}',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              backgroundColor: CarvoraColors.gold,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Visual Art
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: AccessoryVisual(
                iconType: a.iconType,
                height: 240,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: CarvoraColors.surfaceHighlight,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: CarvoraColors.gold.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Text(
                          a.badge.toUpperCase(),
                          style: const TextStyle(
                            color: CarvoraColors.gold,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: CarvoraColors.gold, size: 16),
                          const SizedBox(width: 5),
                          Text(
                            a.rating.toStringAsFixed(2),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${a.reviewsCount} reviews)',
                            style: const TextStyle(
                              color: CarvoraColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Name & Subtitle
                  Text(
                    a.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    a.subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: CarvoraColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Price
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CarvoraColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: CarvoraColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BESPOKE LIST PRICE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: CarvoraColors.textMuted,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Includes All-India Insured Express Delivery',
                              style: TextStyle(
                                fontSize: 12,
                                color: CarvoraColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          formatINR(a.price),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: CarvoraColors.gold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'OVERVIEW',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: CarvoraColors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    a.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: CarvoraColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Key Highlights
                  const Text(
                    'CRAFTSMANSHIP HIGHLIGHTS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: CarvoraColors.gold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...a.highlights.map(
                    (highlight) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 4, right: 10),
                            child: Icon(
                              Icons.diamond_outlined,
                              size: 14,
                              color: CarvoraColors.gold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              highlight,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: CarvoraColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Technical Specifications Table
                  const Text(
                    'TECHNICAL SPECIFICATIONS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: CarvoraColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: CarvoraColors.surfaceHighlight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: CarvoraColors.border),
                    ),
                    child: Column(
                      children: a.specifications.entries.map((entry) {
                        final isLast = entry.key == a.specifications.keys.last;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: isLast
                                ? null
                                : const Border(
                                    bottom: BorderSide(color: CarvoraColors.border),
                                  ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: CarvoraColors.textSecondary,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  entry.value,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: BoxDecoration(
          color: CarvoraColors.surface,
          border: const Border(
            top: BorderSide(color: CarvoraColors.border),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Quantity Selector
            Container(
              decoration: BoxDecoration(
                color: CarvoraColors.surfaceHighlight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: CarvoraColors.border),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                    icon: const Icon(Icons.remove, size: 16),
                    color: CarvoraColors.gold,
                  ),
                  Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _quantity++),
                    icon: const Icon(Icons.add, size: 16),
                    color: CarvoraColors.gold,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Add to Order button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  provider.addToCart(a, quantity: _quantity);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: CarvoraColors.surfaceElevated,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: CarvoraColors.gold, width: 0.8),
                      ),
                      content: Text(
                        'Added $_quantity x ${a.name} to order',
                        style: const TextStyle(color: Colors.white),
                      ),
                      action: SnackBarAction(
                        label: 'VIEW CART',
                        textColor: CarvoraColors.gold,
                        onPressed: () => provider.setNavIndex(3),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_bag_outlined),
                label: Text('ORDER (${formatINR(a.price * _quantity)})'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
