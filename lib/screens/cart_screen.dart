import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rohanmandalas/providers/store_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();
    final cartItems = store.getCartProducts();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: cartItems.isEmpty
          ? const Center(
              child: Text('Your cart is empty.'),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: cartItems.map((product) {
                      final quantity = store.cart[product.id] ?? 1;
                      final subtotal = product.price * quantity;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                product.images.first,
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 8),
                                  Text('₹${product.price.toStringAsFixed(0)}'),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => store.updateCartQuantity(product.id, quantity - 1),
                                        icon: const Icon(Icons.remove),
                                      ),
                                      Text(quantity.toString()),
                                      IconButton(
                                        onPressed: () => store.updateCartQuantity(product.id, quantity + 1),
                                        icon: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text('₹${subtotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 12),
                                TextButton(
                                  onPressed: () => store.removeFromCart(product.id),
                                  child: const Text('Remove'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Order Summary', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 18),
                        _SummaryRow(label: 'Subtotal', value: '₹${store.subtotal.toStringAsFixed(0)}'),
                        _SummaryRow(label: 'Shipping', value: '₹${store.shipping.toStringAsFixed(0)}'),
                        _SummaryRow(label: 'Discount', value: '-₹${store.discount.toStringAsFixed(0)}'),
                        const Divider(height: 28),
                        _SummaryRow(label: 'Total', value: '₹${store.total.toStringAsFixed(0)}', bold: true),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            backgroundColor: const Color(0xFF3B1F2B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text('Proceed to Checkout'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
        ],
      ),
    );
  }
}
