import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carvora_provider.dart';
import '../theme/carvora_theme.dart';
import '../utils/currency_formatter.dart';
import '../widgets/accessory_visual.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();
  bool _promoApplied = false;
  double _discountPercent = 0.0;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoController.text.trim().toUpperCase();
    if (code == 'CARVORA10' || code == 'VIP') {
      setState(() {
        _promoApplied = true;
        _discountPercent = 0.10;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: CarvoraColors.success,
          behavior: SnackBarBehavior.floating,
          content: Text('VIP 10% Privilege Code Applied!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: CarvoraColors.error,
          behavior: SnackBarBehavior.floating,
          content: Text('Invalid code. Try "CARVORA10" or "VIP"'),
        ),
      );
    }
  }

  void _showCheckoutDialog(BuildContext context, CarvoraProvider provider) {
    final subtotal = provider.cartSubtotal;
    final discount = subtotal * _discountPercent;
    final discountedSubtotal = subtotal - discount;
    final tax = discountedSubtotal * 0.08;
    final total = discountedSubtotal + tax;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CarvoraColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: CarvoraColors.gold, width: 1.2),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: CarvoraColors.gold, size: 28),
            SizedBox(width: 12),
            Text(
              'ORDER CONFIRMED',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #CRV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              style: const TextStyle(
                color: CarvoraColors.cyanAccent,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Thank you for entrusting CARVORA with your bespoke vehicle enhancements. Our atelier master will inspect, balance, and package your commission in climate-sealed presentation cases.',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: CarvoraColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CarvoraColors.surfaceHighlight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: CarvoraColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Billed:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  Text(
                    formatINR(total),
                    style: const TextStyle(
                      color: CarvoraColors.gold,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              provider.clearCart();
              Navigator.pop(ctx);
              provider.setNavIndex(0);
            },
            child: const Text('RETURN TO SHOWCASE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarvoraProvider>();
    final items = provider.cartItems;

    if (items.isEmpty) {
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
                child: const Icon(Icons.shopping_bag_outlined, size: 48, color: CarvoraColors.gold),
              ),
              const SizedBox(height: 20),
              const Text(
                'YOUR BESPOKE ORDER IS EMPTY',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select from our high-performance aerodynamic kits, dry carbon wheels, and titanium acoustics.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: CarvoraColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => provider.setNavIndex(1),
                child: const Text('BROWSE CATALOG'),
              ),
            ],
          ),
        ),
      );
    }

    final subtotal = provider.cartSubtotal;
    final discount = subtotal * _discountPercent;
    final discountedSubtotal = subtotal - discount;
    final tax = discountedSubtotal * 0.08;
    final total = discountedSubtotal + tax;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BESPOKE ORDER',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${provider.cartCount} items currently in atelier queue',
                    style: const TextStyle(fontSize: 12, color: CarvoraColors.textSecondary),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => provider.clearCart(),
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: CarvoraColors.textMuted, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Items list
          ...items.map((cartItem) {
            final a = cartItem.accessory;
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CarvoraColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: CarvoraColors.border),
              ),
              child: Row(
                children: [
                  // Visual Thumbnail
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: AccessoryVisual(
                      iconType: a.iconType,
                      height: 80,
                      showAmbientGlow: false,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Item details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${formatINR(a.price)} each',
                          style: const TextStyle(
                            fontSize: 12,
                            color: CarvoraColors.gold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Quantity selector
                        Row(
                          children: [
                            Container(
                              height: 32,
                              decoration: BoxDecoration(
                                color: CarvoraColors.surfaceHighlight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: CarvoraColors.border),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 30),
                                    onPressed: () => provider.updateCartQuantity(a.id, -1),
                                    icon: const Icon(Icons.remove, size: 14, color: CarvoraColors.gold),
                                  ),
                                  Text(
                                    '${cartItem.quantity}',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 30),
                                    onPressed: () => provider.updateCartQuantity(a.id, 1),
                                    icon: const Icon(Icons.add, size: 14, color: CarvoraColors.gold),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              formatINR(cartItem.totalPrice),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 16),

          // VIP Privilege Code Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: CarvoraColors.surfaceHighlight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CarvoraColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      hintText: 'Enter VIP Code (e.g. CARVORA10)',
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _applyPromo,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: const Text('APPLY'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Financial Breakdown
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: CarvoraColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: CarvoraColors.border),
            ),
            child: Column(
              children: [
                _ReceiptRow(label: 'Atelier Subtotal', value: formatINR(subtotal)),
                if (_promoApplied)
                  _ReceiptRow(
                    label: 'VIP Privilege Discount (10%)',
                    value: '-${formatINR(discount)}',
                    isDiscount: true,
                  ),
                const _ReceiptRow(label: 'Insured Pan-India Transit', value: 'Complimentary'),
                _ReceiptRow(label: 'Estimated GST (18%)', value: formatINR(tax)),
                const Divider(color: CarvoraColors.border, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL DUE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      formatINR(total),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: CarvoraColors.gold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => _showCheckoutDialog(context, provider),
              icon: const Icon(Icons.lock_outline, size: 20),
              label: const Text('DISPATCH BESPOKE ORDER'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDiscount;

  const _ReceiptRow({
    required this.label,
    required this.value,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: CarvoraColors.textSecondary)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDiscount ? CarvoraColors.success : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
