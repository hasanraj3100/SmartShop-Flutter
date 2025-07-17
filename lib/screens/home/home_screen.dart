// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart'; // Import ProductProvider
import '../../providers/cart_provider.dart'; // Import CartProvider
import '../../widgets/product_tile.dart'; // Import ProductTile
import '../../widgets/category_tile.dart'; // Import CategoryTile
import '../../core/routes/app_routes.dart'; // For navigation

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch products and categories when the screen initializes
    // Using Future.microtask to ensure context is available after build
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<ProductProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access providers
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context); // Keep for bottom nav cart count

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // No back button on home screen
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search keywords...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                  ),
                  onTap: () {
                    // TODO: Implement search functionality or navigate to search screen
                    print('Search bar tapped');
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Placeholder for potential filter/menu icon if needed
            // IconButton(
            //   icon: Icon(Icons.menu),
            //   onPressed: () {},
            // ),
          ],
        ),
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : productProvider.errorMessage != null
          ? Center(child: Text('Error: ${productProvider.errorMessage}')) // Show error message
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: NetworkImage('https://placehold.co/600x200/ADD8E6/FFFFFF?text=20%25+off+on+your+first+purchase'), // Placeholder
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
                      // TODO: Navigate to all categories screen
                      print('View all categories');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100, // Height for the horizontal category list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: productProvider.categories.length, // Use actual categories count from provider
                itemBuilder: (context, index) {
                  final category = productProvider.categories[index];
                  // Map category names to specific icons for better visual representation
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
                    child: CategoryTile(category: category, icon: categoryIcon), // Use CategoryTile
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Featured Products Section
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
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    onPressed: () {
                      // TODO: Navigate to all featured products screen
                      print('View all featured products');
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true, // Important for nested scroll views
                physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.75, // Adjust as needed for product tile size
                ),
                itemCount: productProvider.products.length, // Use actual products count from provider
                itemBuilder: (context, index) {
                  final product = productProvider.products[index];
                  return ProductTile(product: product); // Use ProductTile
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensures all items are visible
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: 0, // Home is the first item
        onTap: (index) {
          // TODO: Implement navigation to different tabs
          if (index == 0) {
            // Already on home
          } else if (index == 1) {
            // Navigator.of(context).pushNamed(AppRoutes.profile); // Example
            print('Navigate to Profile');
          } else if (index == 2) {
            // Navigator.of(context).pushNamed(AppRoutes.favourites); // Example
            print('Navigate to Favourites');
          } else if (index == 3) {
            Navigator.of(context).pushNamed(AppRoutes.cart); // Example
            print('Navigate to Cart');
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '', // No label as per image
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
