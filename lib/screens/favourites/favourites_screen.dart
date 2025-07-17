// lib/screens/favourites/favourites_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favourites_provider.dart';
import '../../widgets/product_tile.dart'; // Re-use the ProductTile
import '../../providers/theme_provider.dart'; // Import ThemeProvider
import '../../providers/cart_provider.dart'; // Import CartProvider for badge
import '../../core/routes/app_routes.dart'; // Import AppRoutes for navigation

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  int _selectedIndex = 2; // Favourites corresponds to index 2

  @override
  void initState() {
    super.initState();
    // Listen to route changes to update selectedIndex
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectedIndex();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update selected index when route changes (e.g., pop back)
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    int newIndex = 2; // Default to Favourites
    if (currentRoute == AppRoutes.home) {
      newIndex = 0;
    } else if (currentRoute == AppRoutes.profile) {
      newIndex = 1;
    } else if (currentRoute == AppRoutes.cart) {
      newIndex = 3;
    }
    if (_selectedIndex != newIndex) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }
  }

  void _onItemTapped(int index) {
    // Only navigate if the tapped index is different from the current selected index
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      // Handle navigation based on index
      if (index == 0) {
        Navigator.of(context).pushNamed(AppRoutes.home);
      } else if (index == 1) {
        Navigator.of(context).pushNamed(AppRoutes.profile);
      } else if (index == 2) {
        // Already on favourites, no navigation needed
      } else if (index == 3) {
        Navigator.of(context).pushNamed(AppRoutes.cart);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context); // Access CartProvider for item count

    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0, // Space between FAB and AppBar
        color: Theme.of(context).bottomAppBarTheme.color ?? (isDarkMode ? Colors.grey[850]! : Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Home Icon
            _buildBottomNavItem(
              outlineIcon: Icons.home_outlined,
              filledIcon: Icons.home,
              index: 0,
              onTap: _onItemTapped,
              isDarkMode: isDarkMode,
              isSelected: _selectedIndex == 0,
            ),
            // Profile Icon
            _buildBottomNavItem(
              outlineIcon: Icons.person_outline,
              filledIcon: Icons.person,
              index: 1,
              onTap: _onItemTapped,
              isDarkMode: isDarkMode,
              isSelected: _selectedIndex == 1,
            ),
            // Favorites Icon
            _buildBottomNavItem(
              outlineIcon: Icons.favorite_outline,
              filledIcon: Icons.favorite,
              index: 2,
              onTap: _onItemTapped,
              isDarkMode: isDarkMode,
              isSelected: _selectedIndex == 2,
            ),
            // The cart icon will be handled by the FloatingActionButton
            const SizedBox(width: 48), // Space for the FAB
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final cartItemCount = cartProvider.itemCount;
          return Stack(
            clipBehavior: Clip.none, // Allows badge to overflow
            children: [
              FloatingActionButton(
                onPressed: () {
                  _onItemTapped(3); // Navigate to cart
                },
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: const CircleBorder(), // Ensures it's a circle
                child: const Icon(Icons.shopping_bag_outlined),
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: -5, // Adjust position as needed
                  top: -5, // Adjust position as needed
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red, // Badge color
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5), // White border for contrast
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // Helper method for bottom navigation items
  Widget _buildBottomNavItem({
    required IconData outlineIcon,
    required IconData filledIcon,
    required int index,
    required Function(int) onTap,
    required bool isDarkMode,
    required bool isSelected,
  }) {
    final Color iconColor = isSelected
        ? (isDarkMode ? Colors.white : Colors.black)
        : (isDarkMode ? Colors.grey[400]! : Colors.grey);
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? filledIcon : outlineIcon,
                color: iconColor,
                weight: isSelected ? 700 : 400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
