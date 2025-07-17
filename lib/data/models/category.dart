// lib/data/models/category.dart
class Category {
  final String name;
  // Added an optional image field, as it might be useful for UI later
  final String? image;
  final int? id; // Added optional ID for consistency with Product model

  Category({required this.name, this.image, this.id});

  // Factory constructor to create a Category from a JSON map
  // Assuming the API returns a list of strings for categories,
  // we'll adapt this if the API provides more structured category data.
  factory Category.fromJson(String name) {
    return Category(name: name);
  }

  // Method to convert a Category to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (image != null) 'image': image,
      if (id != null) 'id': id,
    };
  }
}
