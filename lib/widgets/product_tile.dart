// lib/widgets/product_tile.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favourites_provider.dart';
import '../providers/theme_provider.dart'; // Import ThemeProvider

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final favouritesProvider = Provider.of<FavouritesProvider>(context); // Listen to changes
    final themeProvider = Provider.of<ThemeProvider>(context); // Access ThemeProvider

    final isFavourite = favouritesProvider.isFavourite(product.id); // Check if product is fav
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // Define colors based on theme mode to maintain current look in light mode
    final tileBackgroundColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black; // Default text color
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600]; // For rating and secondary info
    final boxShadowColor = isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey.withOpacity(0.1);
    final errorImageBgColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];
    final errorImageContentColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];


    return Container(
      decoration: BoxDecoration(
        color: tileBackgroundColor, // Adapts to theme
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: boxShadowColor, // Adapts to theme
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image + Heart Button
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                            color: Theme.of(context).primaryColor, // Loading indicator color
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container( // Use a Container for error placeholder background
                          color: errorImageBgColor, // Adapts to theme
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported, color: errorImageContentColor, size: 40),
                                Text(
                                  'Image Failed',
                                  style: TextStyle(color: errorImageContentColor, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Heart Icon Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      favouritesProvider.toggleFavourite(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isFavourite
                              ? '${product.title} removed from favorites!'
                              : '${product.title} added to favorites!'),
                        ),
                      );
                    },
                    child: Container( // Wrap icon in Container for background and padding
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.8), // Adapts to theme
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavourite ? Icons.favorite : Icons.favorite_border,
                        color: isFavourite ? Colors.red : (isDarkMode ? Colors.grey[400] : Colors.grey), // Adapts to theme
                        size: 24, // Ensure consistent size
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product Info
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: textColor), // Adapts to theme
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor, // Primary color for price
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(
                      '${product.rating.rate.toStringAsFixed(1)} (${product.rating.count})',
                      style: TextStyle(fontSize: 12, color: secondaryTextColor), // Adapts to theme
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity, // Take full width
                  padding: const EdgeInsets.symmetric(horizontal: 0.0), // Removed horizontal padding here
                  child: OutlinedButton.icon(
                    onPressed: () {
                      cartProvider.addToCart(product); // Add product to cart
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.title} added to cart!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor, // Text and icon color
                      side: BorderSide(color: Theme.of(context).primaryColor), // Border color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: isDarkMode ? Colors.transparent : null, // Transparent background in dark mode
                    ),
                    icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                    label: const Text('Add to cart', style: TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
