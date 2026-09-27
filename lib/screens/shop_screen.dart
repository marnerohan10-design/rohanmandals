import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rohanmandalas/models/product.dart';
import 'package:rohanmandalas/providers/store_provider.dart';
import 'package:rohanmandalas/screens/home_screen.dart';
import 'package:rohanmandalas/theme/app_theme.dart';

class ShopScreen extends StatelessWidget {
  final ValueChanged<Product> onOpenProduct;

  const ShopScreen({super.key, required this.onOpenProduct});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();
    final products = store.filteredProducts;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _FilterChip(label: 'All Art', category: ProductCategory.all),
              _FilterChip(label: 'Original Mandala', category: ProductCategory.original),
              _FilterChip(label: 'Framed Art', category: ProductCategory.framed),
              _FilterChip(label: 'Mini Mandala', category: ProductCategory.mini),
              _FilterChip(label: 'Digital Art', category: ProductCategory.digital),
              _FilterChip(label: 'Custom Art', category: ProductCategory.custom),
              _FilterChip(label: 'Gifts', category: ProductCategory.gifts),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search by name, description, tag...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: store.setSearchQuery,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEDE5DC)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: store.sortBy,
                    items: const [
                      'Featured',
                      'Newest',
                      'Price Low to High',
                      'Price High to Low',
                      'Most Popular',
                    ].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                    onChanged: (value) => value != null ? store.setSort(value) : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (_, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onPressed: () => onOpenProduct(product),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final ProductCategory category;

  const _FilterChip({required this.label, required this.category});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();
    final selected = store.selectedCategory == category;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => store.setCategory(category),
      selectedColor: AppTheme.parchment,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: selected ? AppTheme.plum : AppTheme.charcoal,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(color: selected ? AppTheme.plum : const Color(0xFFE6D8CC)),
    );
  }
}
