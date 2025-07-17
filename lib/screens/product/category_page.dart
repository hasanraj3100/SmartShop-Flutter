// lib/screens/product/category_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/category_tile.dart';
import '../../core/routes/app_routes.dart'; // For navigation

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    // Ensure categories are fetched when this page loads
    Future.microtask(() => Provider.of<ProductProvider>(context, listen: false).fetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    // Define colors directly from Theme.of(context)
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : productProvider.errorMessage != null
          ? Center(child: Text('Error: ${productProvider.errorMessage}'))
          : productProvider.categories.isEmpty
          ? Center(
        child: Text(
          'No categories found.',
          style: TextStyle(color: secondaryTextColor, fontSize: 16),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Display categories in 2 columns
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.0, // Square tiles for categories
        ),
        itemCount: productProvider.categories.length,
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
          return GestureDetector(
            onTap: () {
              // Navigate to CategoryProductsScreen, passing the category name

              Navigator.of(context).pushNamed(
                AppRoutes.categoryProducts,
                arguments: category.name,
              );
            },
            child: CategoryTile(
              category: category,
              icon: categoryIcon,
            ),
          );
        },
      ),
    );
  }
}
