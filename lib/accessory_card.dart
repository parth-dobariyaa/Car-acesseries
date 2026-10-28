import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/accessory.dart';
import '../providers/carvora_provider.dart';
import '../theme/carvora_theme.dart';
import '../utils/currency_formatter.dart';
import 'accessory_visual.dart';

class AccessoryCard extends StatelessWidget {
  final Accessory accessory;
  final VoidCallback onTap;

  const AccessoryCard({
    super.key,
    required this.accessory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarvoraProvider>();
    final isWishlisted = provider.isWishlisted(accessory.id);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: CarvoraColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: CarvoraColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visual header with Badge & Wishlist button
            Stack(
              children: [
                AccessoryVisual(
                  iconType: accessory.iconType,
                  height: 150,
                ),

                // Top Badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: CarvoraColors.background.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: CarvoraColors.gold.withValues(alpha: 0.5),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      accessory.badge.toUpperCase(),
                      style: const TextStyle(
                        color: CarvoraColors.gold,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),

                // Wishlist Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => provider.toggleWishlist(accessory.id),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CarvoraColors.background.withValues(alpha: 0.8),
                          border: Border.all(
                            color: CarvoraColors.border,
                            width: 0.8,
                          ),
                        ),
                        child: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isWishlisted ? Colors.redAccent : CarvoraColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category tag
                  Text(
                    accessory.category.toUpperCase(),
                    style: const TextStyle(
                      color: CarvoraColors.cyanAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Name
                  Text(
                    accessory.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: CarvoraColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Subtitle
                  Text(
                    accessory.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: CarvoraColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Rating row
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: CarvoraColors.gold),
                      const SizedBox(width: 4),
                      Text(
                        accessory.rating.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: CarvoraColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${accessory.reviewsCount})',
                        style: const TextStyle(
                          fontSize: 11,
                          color: CarvoraColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Price and Add to Cart Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PRICE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                              color: CarvoraColors.textMuted,
                            ),
                          ),
                          Text(
                            formatINR(accessory.price),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: CarvoraColors.gold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: CarvoraColors.surfaceHighlight,
                          foregroundColor: CarvoraColors.gold,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: CarvoraColors.borderHighlight,
                              width: 0.8,
                            ),
                          ),
                        ),
                        onPressed: () {
                          provider.addToCart(accessory);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: CarvoraColors.surfaceElevated,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(color: CarvoraColors.gold, width: 0.8),
                              ),
                              content: Row(
                                children: [
                                  const Icon(Icons.check_circle, color: CarvoraColors.gold, size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Added ${accessory.name} to cart',
                                      style: const TextStyle(color: Colors.white, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
