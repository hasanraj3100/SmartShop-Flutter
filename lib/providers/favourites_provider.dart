// lib/providers/favourites_provider.dart
import 'package:flutter/material.dart';
import '../data/models/product.dart'; // Import the Product model

class FavouritesProvider with ChangeNotifier {
  final List<Product> _favouriteProducts = [];

  List<Product> get favouriteProducts => _favouriteProducts;

  // Checks if a product is in the favorites list
  bool isFavorite(Product product) {
    // We compare by product ID to ensure uniqueness and correct identification
    return _favouriteProducts.any((favProduct) => favProduct.id == product.id);
  }

  // Toggles the favorite status of a product
  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      // If already a favorite, remove it
      _favouriteProducts.removeWhere((favProduct) => favProduct.id == product.id);
    } else {
      // If not a favorite, add it
      _favouriteProducts.add(product);
    }
    notifyListeners(); // Notify listeners to update UI
  }

// You might want to add methods to load/save favorites to SharedPreferences later
}
