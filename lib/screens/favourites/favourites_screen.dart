// lib/screens/favourites/favourites_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favourites_provider.dart';
import '../../widgets/product_tile.dart'; // Re-use the ProductTile

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FavouritesProvider>(context);

    // Determine if dark mode is active for theme adaptation
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];


    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favourites'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: favouritesProvider.favourites.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No favourite products yet!',
              style: TextStyle(fontSize: 18, color: secondaryTextColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart icon on products to add them here.',
              style: TextStyle(fontSize: 14, color: secondaryTextColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two columns as seen on home screen
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.75, // Match ProductTile aspect ratio
        ),
        itemCount: favouritesProvider.favourites.length,
        itemBuilder: (context, index) {
          final product = favouritesProvider.favourites[index];
          return ProductTile(product: product); // Re-use ProductTile
        },
      ),
    );
  }
}
