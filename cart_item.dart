import 'accessory.dart';

class CartItem {
  final Accessory accessory;
  int quantity;

  CartItem({
    required this.accessory,
    this.quantity = 1,
  });

  double get totalPrice => accessory.price * quantity;
}
