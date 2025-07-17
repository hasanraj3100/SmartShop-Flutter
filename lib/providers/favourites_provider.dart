// lib/providers/favourites_provider.dart
import 'package:flutter/material.dart';
import '../data/models/product.dart';

class FavouritesProvider with ChangeNotifier {
  final List<Product> _favourites = [];

  List<Product> get favourites => _favourites;

  bool isFavourite(int productId) {
    return _favourites.any((product) => product.id == productId);
  }

  void toggleFavourite(Product product) {
    final index = _favourites.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _favourites.removeAt(index);
    } else {
      _favourites.add(product);
    }
    notifyListeners();
  }
}
