import 'package:flutter/foundation.dart';
import '../models/accessory.dart';
import '../models/cart_item.dart';
import '../models/consultation.dart';
import '../data/sample_accessories.dart';

class CarvoraProvider extends ChangeNotifier {
  int _currentNavIndex = 0;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final Set<String> _wishlistIds = {'crv-01', 'crv-04'};
  final List<CartItem> _cartItems = [];
  final List<ConsultationRequest> _consultations = [];
  bool _isAdminAuthenticated = false;
  String? _registeredEmail;
  String? _registeredPassword;
  String? _signedInEmail;
  final Map<String, int> _inventory = {
    for (final accessory in kSampleAccessories) accessory.id: 12,
  };

  CarvoraProvider() {
    // Add default initial cart item for showcase preview
    _cartItems.add(CartItem(accessory: kSampleAccessories[0], quantity: 1));
  }

  // Getters
  int get currentNavIndex => _currentNavIndex;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  Set<String> get wishlistIds => _wishlistIds;
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  List<ConsultationRequest> get consultations => List.unmodifiable(_consultations);
  bool get isAdminAuthenticated => _isAdminAuthenticated;
  bool get isUserAuthenticated => _signedInEmail != null;
  String? get signedInEmail => _signedInEmail;
  Map<String, int> get inventory => Map.unmodifiable(_inventory);

  List<Accessory> get allAccessories => kSampleAccessories;

  List<Accessory> get featuredAccessories =>
      kSampleAccessories.where((a) => a.isFeatured).toList();

  List<Accessory> get wishlistAccessories =>
      kSampleAccessories.where((a) => _wishlistIds.contains(a.id)).toList();

  List<Accessory> get filteredAccessories {
    return kSampleAccessories.where((a) {
      final matchesCategory = _selectedCategory == 'All' || a.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          a.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          a.subtitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          a.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get cartSubtotal => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get cartTax => cartSubtotal * 0.18;

  double get cartTotal => cartSubtotal + cartTax;

  // Actions
  void setNavIndex(int index) {
    if (_currentNavIndex != index) {
      _currentNavIndex = index;
      notifyListeners();
    }
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleWishlist(String id) {
    if (_wishlistIds.contains(id)) {
      _wishlistIds.remove(id);
    } else {
      _wishlistIds.add(id);
    }
    notifyListeners();
  }

  bool isWishlisted(String id) => _wishlistIds.contains(id);

  void addToCart(Accessory accessory, {int quantity = 1}) {
    final index = _cartItems.indexWhere((item) => item.accessory.id == accessory.id);
    if (index >= 0) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(CartItem(accessory: accessory, quantity: quantity));
    }
    notifyListeners();
  }

  void updateCartQuantity(String accessoryId, int delta) {
    final index = _cartItems.indexWhere((item) => item.accessory.id == accessoryId);
    if (index >= 0) {
      final newQuantity = _cartItems[index].quantity + delta;
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void removeFromCart(String accessoryId) {
    _cartItems.removeWhere((item) => item.accessory.id == accessoryId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void submitConsultation(ConsultationRequest request) {
    _consultations.insert(0, request);
    notifyListeners();
  }

  bool loginAsAdmin(String email, String password) {
    if (email.trim().toLowerCase() != 'admin@carvora.com' || password != 'admin123') {
      return false;
    }
    _isAdminAuthenticated = true;
    notifyListeners();
    return true;
  }

  void logoutAdmin() {
    _isAdminAuthenticated = false;
    notifyListeners();
  }

  void updateInventory(String accessoryId, int quantity) {
    if (!_inventory.containsKey(accessoryId)) return;
    _inventory[accessoryId] = quantity.clamp(0, 999);
    notifyListeners();
  }

  bool registerUser(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty || password.length < 6) return false;
    _registeredEmail = normalizedEmail;
    _registeredPassword = password;
    _signedInEmail = null;
    notifyListeners();
    return true;
  }

  bool loginUser(String email, String password) {
    if (email.trim().toLowerCase() != _registeredEmail || password != _registeredPassword) {
      return false;
    }
    _signedInEmail = _registeredEmail;
    notifyListeners();
    return true;
  }

  void logoutUser() {
    _signedInEmail = null;
    notifyListeners();
  }
}
