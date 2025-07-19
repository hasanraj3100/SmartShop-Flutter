// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart'; // Import CartProvider
import '../../widgets/product_tile.dart';
import '../../widgets/category_tile.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/theme_provider.dart'; // Add ThemeProvider

enum ProductSortOption {
  none,
  priceAsc,
  priceDesc,
  ratingAsc,
  ratingDesc,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ProductSortOption _currentSortOption = ProductSortOption.none;
  int _selectedIndex = 0; // To manage the selected tab in BottomNavigationBar

  @override
  void initState() {
    super.initState();
    // Listen to route changes to update selectedIndex
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectedIndex();
    });
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<ProductProvider>(context, listen: false).fetchCategories();
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
    int newIndex = 0; // Default to Home
    if (currentRoute == AppRoutes.profile) {
      newIndex = 1;
    } else if (currentRoute == AppRoutes.favourites) {
      newIndex = 2;
    } else if (currentRoute == AppRoutes.cart) {
      newIndex = 3;
    }
    if (_selectedIndex != newIndex) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }
  }

  void _sortProducts(ProductSortOption option) {
    setState(() {
      _currentSortOption = option;
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.sortProducts(option); // Call sort method on provider
    });
  }

  void _logout() {
    // TODO: Implement logout functionality
    Navigator.pushReplacementNamed(context, AppRoutes.login);
    print('User logged out');
  }

  void _onItemTapped(int index) {
    // Only navigate if the tapped index is different from the current selected index
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      // Handle navigation based on index
      if (index == 0) {
        // Already on home, no navigation needed, but pop other routes if any
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (index == 1) {
        Navigator.of(context).pushNamed(AppRoutes.profile);
      } else if (index == 2) {
        Navigator.of(context).pushNamed(AppRoutes.favourites);
      } else if (index == 3) {
        Navigator.of(context).pushNamed(AppRoutes.cart);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context); // Theme provider
    final cartProvider = Provider.of<CartProvider>(context); // Access CartProvider for item count
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        title: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey.shade400,
              width: 1,
            ),
            boxShadow: [
              if (!isDarkMode)
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 16,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(bottom: 2),
              ),
              onTap: () {
                print('Search bar tapped');
              },
            ),
          ),
        ),
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      drawer: _buildDrawer(context, themeProvider, isDarkMode),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : productProvider.errorMessage != null
          ? Center(child: Text('Error: ${productProvider.errorMessage}'))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(
                        image: AssetImage('banner.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          '20% off on your\nfirst purchase',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.category); // Corrected route
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: productProvider.categories.length,
                itemBuilder: (context, index) {
                  final category = productProvider.categories[index];
                  IconData? categoryIcon;
                  switch (category.name.toLowerCase()) {
                    case 'electronics':
                      categoryIcon = Icons.devices_other;
                      break;
                    case 'jewelery':
                      categoryIcon = Icons.diamond;
                      break;
                    case 'men\'s clothing':
                      categoryIcon = Icons.man;
                      break;
                    case 'women\'s clothing':
                      categoryIcon = Icons.woman;
                      break;
                    default:
                      categoryIcon = Icons.category;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: CategoryTile(category: category, icon: categoryIcon),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Featured Products Section with Sort Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured products',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Sort Options Dropdown
                  PopupMenuButton<ProductSortOption>(
                    icon: Icon(Icons.sort, color: isDarkMode ? Colors.white : Colors.black),
                    onSelected: _sortProducts,
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<ProductSortOption>>[
                      const PopupMenuItem<ProductSortOption>(
                        value: ProductSortOption.none,
                        child: Text('Default'),
                      ),
                      const PopupMenuItem<ProductSortOption>(
                        value: ProductSortOption.priceAsc,
                        child: Text('Price: Low to High'),
                      ),
                      const PopupMenuItem<ProductSortOption>(
                        value: ProductSortOption.priceDesc,
                        child: Text('Price: High to Low'),
                      ),
                      const PopupMenuItem<ProductSortOption>(
                        value: ProductSortOption.ratingDesc,
                        child: Text('Rating: High to Low'),
                      ),
                      const PopupMenuItem<ProductSortOption>(
                        value: ProductSortOption.ratingAsc,
                        child: Text('Rating: Low to High'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: productProvider.products.length,
                itemBuilder: (context, index) {
                  final product = productProvider.products[index];
                  return ProductTile(product: product);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
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
              isSelected: _selectedIndex == 0, // Pass isSelected state
            ),
            // Profile Icon
            _buildBottomNavItem(
              outlineIcon: Icons.person_outline,
              filledIcon: Icons.person,
              index: 1,
              onTap: _onItemTapped,
              isDarkMode: isDarkMode,
              isSelected: _selectedIndex == 1, // Pass isSelected state
            ),
            // Favorites Icon
            _buildBottomNavItem(
              outlineIcon: Icons.favorite_outline,
              filledIcon: Icons.favorite,
              index: 2,
              onTap: _onItemTapped,
              isDarkMode: isDarkMode,
              isSelected: _selectedIndex == 2, // Pass isSelected state
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
    required bool isSelected, // New parameter to control highlighting
  }) {
    final Color iconColor = isSelected
        ? (isDarkMode ? Colors.white : Colors.black) // Darker/white for selected
        : (isDarkMode ? Colors.grey[400]! : Colors.grey); // Grey for unselected
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: SizedBox(
          height: kBottomNavigationBarHeight, // Standard height for nav bar items
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? filledIcon : outlineIcon,
                color: iconColor,
                weight: isSelected ? 700 : 400, // Make selected icon thicker
              ),
              // No label as per image
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, ThemeProvider themeProvider, bool isDarkMode) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Oasimul Raj',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'raj@example.com',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // TODO: Navigate to settings
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Order History'),
            onTap: () {
              // TODO: Navigate to order history
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            title: Text(isDarkMode ? 'Light Mode' : 'Dark Mode'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
                Navigator.pop(context);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              _logout();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              // TODO: Show help/support
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
