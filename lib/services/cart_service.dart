import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // CREATE - Add item to cart
  void addItem(Product product, int quantity, String size) {
    // Check if product with same size already exists
    final existingIndex = _items.indexWhere(
      (item) => item.product.name == product.name && item.size == size,
    );

    if (existingIndex >= 0) {
      // Update existing item quantity
      _items[existingIndex].quantity += quantity;
    } else {
      // Add new item
      _items.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          product: product,
          quantity: quantity,
          size: size,
        ),
      );
    }
    notifyListeners();
  }

  // READ - Get specific item
  CartItem? getItem(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // UPDATE - Update item quantity
  void updateItemQuantity(String id, int newQuantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (newQuantity <= 0) {
        removeItem(id);
      } else {
        _items[index].quantity = newQuantity;
        notifyListeners();
      }
    }
  }

  // UPDATE - Update item size
  void updateItemSize(String id, String newSize) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].size = newSize;
      notifyListeners();
    }
  }

  // DELETE - Remove specific item
  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // DELETE - Clear all items
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Increment quantity
  void incrementQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  // Decrement quantity
  void decrementQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        notifyListeners();
      } else {
        removeItem(id);
      }
    }
  }

  // Check if product exists in cart
  bool hasProduct(String productName) {
    return _items.any((item) => item.product.name == productName);
  }

  // Get cart item count for specific product
  int getProductQuantity(String productName) {
    return _items
        .where((item) => item.product.name == productName)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  // Update quantity by product (for order detail page)
  void updateQuantity(Product product, int newQuantity) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  // Remove from cart by product (for order detail page)
  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }
}
