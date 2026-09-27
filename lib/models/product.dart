enum ProductCategory {
  all,
  original,
  framed,
  mini,
  digital,
  custom,
  gifts,
}

class Product {
  final String id;
  final String name;
  final String slug;
  final String description;
  final double price;
  final ProductCategory category;
  final List<String> images;
  final double rating;
  final int reviews;
  final String size;
  final String material;
  final String availability;
  final bool featured;
  final String dimensions;
  final String technique;
  final String creationTime;
  final List<String> tags;
  final List<String> colors;

  const Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    required this.rating,
    required this.reviews,
    required this.size,
    required this.material,
    required this.availability,
    required this.featured,
    required this.dimensions,
    required this.technique,
    required this.creationTime,
    required this.tags,
    required this.colors,
  });

  String get categoryLabel {
    switch (category) {
      case ProductCategory.original:
        return 'Original Mandala';
      case ProductCategory.framed:
        return 'Framed Art';
      case ProductCategory.mini:
        return 'Mini Mandala';
      case ProductCategory.digital:
        return 'Digital Art';
      case ProductCategory.custom:
        return 'Custom Art';
      case ProductCategory.gifts:
        return 'Gifts';
      case ProductCategory.all:
        return 'All Art';
    }
  }
}

extension ProductCategoryExt on ProductCategory {
  String get value => switch (this) {
    ProductCategory.all => 'All Art',
    ProductCategory.original => 'Original Mandala',
    ProductCategory.framed => 'Framed Art',
    ProductCategory.mini => 'Mini Mandala',
    ProductCategory.digital => 'Digital Art',
    ProductCategory.custom => 'Custom Art',
    ProductCategory.gifts => 'Gifts',
  };
}
