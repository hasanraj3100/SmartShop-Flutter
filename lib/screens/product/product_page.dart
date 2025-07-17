// lib/screens/product/product_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favourites_provider.dart';
import '../../providers/theme_provider.dart'; // For theme adaptation

class ProductPage extends StatefulWidget {
  final Product product; // Product to display

  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _quantity = 1; // Initial quantity for the product

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final isFavourite = favouritesProvider.isFavourite(widget.product.id);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // Define colors based on theme mode
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.7);
    final cardColor = Theme.of(context).cardColor;
    final dividerColor = Theme.of(context).dividerColor;


    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor), // Icon color adapts to theme
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // Removed actions here to move favorite button out of AppBar
      ),
      body: Column( // Use Column to separate scrollable content from fixed bottom bar
        children: [
          Expanded( // Scrollable content
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image Section
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    color: Theme.of(context).primaryColor.withOpacity(0.1), // Light background for image area
                    child: Center(
                      child: Image.network(
                        widget.product.image,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image, color: secondaryTextColor, size: 80);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Product Details Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price and Heart Icon (moved here)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${widget.product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Heart Icon Button (moved from AppBar)
                            Consumer<FavouritesProvider>(
                              builder: (context, favouritesProvider, child) {
                                final isFavorite = favouritesProvider.isFavourite(widget.product.id);
                                return IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : textColor, // Favorite icon color adapts
                                  ),
                                  onPressed: () {
                                    favouritesProvider.toggleFavourite(widget.product);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(isFavorite
                                            ? '${widget.product.title} removed from favorites!'
                                            : '${widget.product.title} added to favorites!'),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Product Title
                        Text(
                          widget.product.title,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Placeholder for "1.50 lbs" or "dozen"
                        Text(
                          '${widget.product.category}', // Using category as placeholder
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Rating
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < widget.product.rating.rate.floor() ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              );
                            }),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.product.rating.rate.toStringAsFixed(1)} (${widget.product.rating.count} reviews)',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Description
                        Text(
                          widget.product.description,
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Removed Quantity Selector from here
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Fixed Bottom "Add to Cart" Button and Quantity Selector
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: backgroundColor, // Background color adapts to theme
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                // Quantity Selector (moved here)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildQuantityButton(
                      icon: Icons.remove,
                      onPressed: () {
                        setState(() {
                          if (_quantity > 1) _quantity--;
                        });
                      },
                      isDarkMode: isDarkMode,
                    ),
                    Container(
                      width: 60,
                      alignment: Alignment.center,
                      child: Text(
                        '$_quantity',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    _buildQuantityButton(
                      icon: Icons.add,
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Spacing between quantity and button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add multiple items to cart based on quantity
                      for (int i = 0; i < _quantity; i++) {
                        cartProvider.addToCart(widget.product);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${_quantity} x ${widget.product.title} added to cart!')),
                      );
                    },
                    icon: const Icon(Icons.shopping_bag_outlined, size: 24),
                    label: const Text(
                      'Add to cart',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for quantity buttons
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: Theme.of(context).primaryColor),
        onPressed: onPressed,
      ),
    );
  }
}
