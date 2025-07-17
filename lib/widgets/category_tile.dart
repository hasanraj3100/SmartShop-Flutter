// lib/widgets/category_tile.dart
import 'package:flutter/material.dart';
import '../data/models/category.dart'; // Assuming your Category model is here
import '../core/routes/app_routes.dart'; // Import AppRoutes for navigation

class CategoryTile extends StatelessWidget {
  final Category category; // We'll pass a Category object to this tile
  final IconData? icon; // Optional icon for categories

  const CategoryTile({super.key, required this.category, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to CategoryProductsScreen, passing the category name
        Navigator.of(context).pushNamed(
          AppRoutes.categoryProducts,
          arguments: category.name, // Pass the full category name
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: icon != null
                ? Icon(icon, color: Theme.of(context).primaryColor)
                : Text(
              category.title[0].toUpperCase(), // Use first letter of title if no icon
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            category.title, // Use category title
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
