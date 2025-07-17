// lib/data/models/category.dart
class Category {
  final String name;
  final String? image;
  final int? id;

  Category({required this.name, this.image, this.id});

  // Factory constructor to create a Category from a JSON map
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

  // New getter for the 'title' property
  String get title {
    if (name.toLowerCase() == "men's clothing") {
      return "Men's";
    } else if (name.toLowerCase() == "women's clothing") {
      return "Women's";
    } else if (name.isNotEmpty) {
      // Capitalize the first letter of the name
      return name[0].toUpperCase() + name.substring(1);
    }
    return ''; // Return empty string or handle as appropriate for empty names
  }
}
