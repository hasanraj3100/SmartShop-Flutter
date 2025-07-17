// lib/providers/product_provider.dart
import 'package:flutter/material.dart';
import '../data/models/product.dart';
import '../data/models/category.dart';
// import '../data/services/api_service.dart'; // Uncomment when ApiService is ready

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // You'll inject ApiService here later
  // final ApiService _apiService = ApiService();

  ProductProvider() {
    // Initial data fetch or setup
    // For now, we'll use dummy data or fetch nothing until ApiService is ready.
  }

  // Method to fetch products (will use ApiService)
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call using ApiService
      // _products = await _apiService.fetchProducts();
      // For now, simulate a delay and use dummy data
      await Future.delayed(const Duration(seconds: 1));
      _products = _generateDummyProducts(); // Using dummy products for now
    } catch (e) {
      _errorMessage = 'Failed to load products: $e';
      print('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to fetch categories (will use ApiService)
  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call using ApiService
      // _categories = await _apiService.fetchCategories();
      // For now, simulate a delay and use dummy data
      await Future.delayed(const Duration(seconds: 1));
      _categories = _generateDummyCategories(); // Using dummy categories for now
    } catch (e) {
      _errorMessage = 'Failed to load categories: $e';
      print('Error fetching categories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Dummy data generation for testing purposes
  List<Product> _generateDummyProducts() {
    return [
      Product(
        id: 1,
        title: 'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops',
        price: 109.95,
        description: "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
        category: "men's clothing",
        image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
        rating: Rating(rate: 3.9, count: 120),
      ),
      Product(
        id: 2,
        title: 'Mens Casual Premium Slim Fit T-Shirts ',
        price: 22.3,
        description: "Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.",
        category: "men's clothing",
        image: "https://fakestoreapi.com/img/71-3HjhnzGL._AC_SY879._SX._UX._SY._UY_.jpg",
        rating: Rating(rate: 4.1, count: 259),
      ),
      Product(
        id: 3,
        title: 'Mens Cotton Jacket',
        price: 55.99,
        description: "great outerwear jackets for Spring/Autumn/Winter, suitable for casual wear, business, dates, parties and other outdoor occasions. It is a good gift for your boyfriend, son, husband, or yourself.",
        category: "men's clothing",
        image: "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg",
        rating: Rating(rate: 4.7, count: 500),
      ),
      Product(
        id: 4,
        title: 'Mens Casual Slim Fit',
        price: 15.99,
        description: "The color could be slightly different between on the screen and in practice. / Please note that body builds vary by person, therefore, detailed size information should be reviewed below on the product description.",
        category: "men's clothing",
        image: "https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg",
        rating: Rating(rate: 2.1, count: 430),
      ),
      Product(
        id: 5,
        title: "John Hardy Women's Legends Naga Gold & Silver Dragon Station Chain Bracelet",
        price: 695,
        description: "From our Legends Collection, the Naga was inspired by the mythical water dragon that protects the ocean's pearl. Wear facing inward to be bestowed with love and abundance, or outward for protection.",
        category: "jewelery",
        image: "https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg",
        rating: Rating(rate: 4.6, count: 400),
      ),
      Product(
        id: 6,
        title: "Solid Gold Petite Micropave ",
        price: 168,
        description: "Satisfaction Guaranteed. Return or exchange any order within 30 days.Designed and sold by Hafeez Center in the United States. Satisfaction Guaranteed. Return or exchange any order within 30 days.",
        category: "jewelery",
        image: "https://fakestoreapi.com/img/61sbMXJC7AL._AC_UL640_QL65_ML3_.jpg",
        rating: Rating(rate: 3.9, count: 70),
      ),
    ];
  }

  List<Category> _generateDummyCategories() {
    return [
      Category(id: 1, name: 'electronics'),
      Category(id: 2, name: 'jewelery'),
      Category(id: 3, name: 'men\'s clothing'),
      Category(id: 4, name: 'women\'s clothing'),
    ];
  }
}
