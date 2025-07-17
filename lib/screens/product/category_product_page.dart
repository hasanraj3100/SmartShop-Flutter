// lib/screens/product/category_products_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_tile.dart'; // Re-use ProductTile

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName; // Category name passed as argument

  const CategoryProductsScreen({super.key, required this.categoryName});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _filterProducts();
  }

  // This method filters products based on the category name
  // In a real API, you might call a specific endpoint like /products/category/jewelery
  void _filterProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      // Ensure products are fetched before filtering
      if (productProvider.products.isEmpty) {
        await productProvider.fetchProducts();
      }

      _filteredProducts = productProvider.products
          .where((product) => product.category.toLowerCase() == widget.categoryName.toLowerCase())
          .toList();
    } catch (e) {
      _errorMessage = 'Failed to load products for ${widget.categoryName}: $e';
      print('Error filtering products: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define colors directly from Theme.of(context)
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.7);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName.toUpperCase()), // Display category name in app bar
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text('Error: ${_errorMessage}'))
          : _filteredProducts.isEmpty
          ? Center(
        child: Text(
          'No products found for ${widget.categoryName}.',
          style: TextStyle(color: secondaryTextColor, fontSize: 16),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.75, // Match ProductTile aspect ratio
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          return ProductTile(product: product); // Re-use ProductTile
        },
      ),
    );
  }
}
