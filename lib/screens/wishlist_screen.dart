import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rohanmandalas/providers/store_provider.dart';

class WishlistScreen extends StatelessWidget {
  final ValueChanged<dynamic> onOpenProduct;

  const WishlistScreen({super.key, required this.onOpenProduct});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();
    final wishlistItems = store.products.where((product) => store.isWishlisted(product.id)).toList();

    return wishlistItems.isEmpty
        ? const Center(child: Text('Your wishlist is empty.'))
        : GridView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: wishlistItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (_, index) {
              final product = wishlistItems[index];
              return InkWell(
                onTap: () => onOpenProduct(product),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          product.images.first,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(product.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text('₹${product.price.toStringAsFixed(0)}'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () => store.addToCart(product),
                              child: const Text('Add to Cart'),
                            ),
                          ),
                          IconButton(
                            onPressed: () => store.toggleWishlist(product.id),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
