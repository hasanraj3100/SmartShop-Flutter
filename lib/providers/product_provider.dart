import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/models/product.dart';
import '../data/models/category.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProductProvider();

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    const url = 'https://fakestoreapi.com/products';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _products = data.map((json) => Product.fromJson(json)).toList();
      } else {
        _errorMessage = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Failed to load products: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    const url = 'https://fakestoreapi.com/products/categories';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _categories = List<Category>.generate(
          data.length,
              (index) => Category(id: index + 1, name: data[index]),
        );
      } else {
        _errorMessage = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Failed to load categories: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
