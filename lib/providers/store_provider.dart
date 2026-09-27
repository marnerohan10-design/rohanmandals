import 'package:flutter/material.dart';
import 'package:rohanmandalas/data/mock_products.dart';
import 'package:rohanmandalas/models/product.dart';

class StoreProvider extends ChangeNotifier {
  final List<Product> _products = MockProducts.products;
  final Map<String, int> _cart = {};
  final Set<String> _wishlist = <String>{};
  String _searchQuery = '';
  ProductCategory _selectedCategory = ProductCategory.all;
  String _sortBy = 'Featured';

  List<Product> get products => _products;
  Map<String, int> get cart => {..._cart};
  Set<String> get wishlist => {..._wishlist};
  String get searchQuery => _searchQuery;
  ProductCategory get selectedCategory => _selectedCategory;
  String get sortBy => _sortBy;

  List<Product> get filteredProducts {
    final query = _searchQuery.trim().toLowerCase();
    final matches = _products.where((product) {
      final categoryMatches = _selectedCategory == ProductCategory.all ||
          product.category == _selectedCategory;
      final queryMatches = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.categoryLabel.toLowerCase().contains(query) ||
          product.tags.any((tag) => tag.toLowerCase().contains(query));
      return categoryMatches && queryMatches;
    }).toList();

    switch (_sortBy) {
      case 'Newest':
        matches.sort((a, b) => b.id.compareTo(a.id));
        break;
      case 'Price Low to High':
        matches.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price High to Low':
        matches.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Most Popular':
        matches.sort((a, b) => b.reviews.compareTo(a.reviews));
        break;
      case 'Featured':
      default:
        matches.sort((a, b) {
          final aWeight = a.featured ? 1 : 0;
          final bWeight = b.featured ? 1 : 0;
          return bWeight.compareTo(aWeight);
        });
    }

    return matches;
  }

  int get cartCount => _cart.values.fold<int>(0, (sum, quantity) => sum + quantity);

  double get subtotal {
    double total = 0;
    for (final entry in _cart.entries) {
      final product = _products.firstWhere((item) => item.id == entry.key, orElse: () => _products.first);
      total += product.price * entry.value;
    }
    return total;
  }

  double get shipping => cartCount > 0 ? 299 : 0;

  double get discount => subtotal > 5000 ? 500 : 0;

  double get total => subtotal + shipping - discount;

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setCategory(ProductCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSort(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  void toggleWishlist(String productId) {
    if (_wishlist.contains(productId)) {
      _wishlist.remove(productId);
    } else {
      _wishlist.add(productId);
    }
    notifyListeners();
  }

  bool isWishlisted(String productId) => _wishlist.contains(productId);

  void addToCart(Product product, {int quantity = 1}) {
    final current = _cart[product.id] ?? 0;
    _cart[product.id] = current + quantity;
    notifyListeners();
  }

  void updateCartQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      _cart.remove(productId);
    } else {
      _cart[productId] = quantity;
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.remove(productId);
    notifyListeners();
  }

  List<Product> getCartProducts() {
    return _cart.entries
        .map((entry) => _products.firstWhere((item) => item.id == entry.key))
        .toList();
  }

  Product? productById(String productId) {
    try {
      return _products.firstWhere((item) => item.id == productId);
    } catch (_) {
      return null;
    }
  }
}
