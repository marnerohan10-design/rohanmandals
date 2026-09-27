import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rohanmandalas/models/product.dart';
import 'package:rohanmandalas/providers/store_provider.dart';
import 'package:rohanmandalas/theme/app_theme.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => store.toggleWishlist(widget.product.id),
                    icon: Icon(
                      store.isWishlisted(widget.product.id) ? Icons.favorite : Icons.favorite_border,
                      color: store.isWishlisted(widget.product.id) ? AppTheme.rust : AppTheme.plum,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Image.network(
                            widget.product.images.first,
                            height: 520,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: widget.product.images
                              .map((image) => Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          image,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.parchment,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            widget.product.categoryLabel,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.plum,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 42),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: AppTheme.gold),
                            const SizedBox(width: 6),
                            Text('${widget.product.rating} (${widget.product.reviews} reviews)'),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '₹${widget.product.price.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 36),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.product.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.8),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFE5DBD1)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () => setState(() => quantity = (quantity > 1) ? quantity - 1 : 1),
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(quantity.toString()),
                                  IconButton(
                                    onPressed: () => setState(() => quantity++),
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: FilledButton(
                                onPressed: () => store.addToCart(widget.product, quantity: quantity),
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(52),
                                  backgroundColor: AppTheme.plum,
                                ),
                                child: const Text('Add to Cart'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => store.addToCart(widget.product, quantity: quantity),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(52),
                                  side: const BorderSide(color: AppTheme.plum),
                                ),
                                child: const Text('Buy Now'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _InfoRow(label: 'Dimensions', value: widget.product.dimensions),
                        _InfoRow(label: 'Material', value: widget.product.material),
                        _InfoRow(label: 'Technique', value: widget.product.technique),
                        _InfoRow(label: 'Creation Time', value: widget.product.creationTime),
                        _InfoRow(label: 'Shipping', value: 'Free shipping across India'),
                        _InfoRow(label: 'Availability', value: widget.product.availability),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedText),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
