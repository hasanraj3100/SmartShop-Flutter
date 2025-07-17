// lib/providers/cart_provider.dart
import 'package:flutter/material.dart';
import '../data/models/product.dart'; // Assuming your Product model is here

class CartProvider with ChangeNotifier {
  final Map<Product, int> _items = {}; // Stores product and its quantity

  Map<Product, int> get items => _items;

  int get itemCount => _items.values.fold(0, (sum, element) => sum + element);

  double get totalPrice {
    double total = 0.0;
    _items.forEach((product, quantity) {
      total += product.price * quantity;
    });
    return total;
  }

  void addToCart(Product product) {
    if (_items.containsKey(product)) {
      _items[product] = _items[product]! + 1;
    } else {
      _items[product] = 1;
    }
    notifyListeners();
  }

  void removeOneFromCart(Product product) {
    if (_items.containsKey(product)) {
      if (_items[product]! > 1) {
        _items[product] = _items[product]! - 1;
      } else {
        _items.remove(product);
      }
      notifyListeners();
    }
  }

  void removeItem(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

// You might want to add methods to load/save cart to SharedPreferences later
}
