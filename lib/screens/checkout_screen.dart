import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rohanmandalas/providers/store_provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Checkout', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 18),
                  const TextField(decoration: InputDecoration(labelText: 'Full Name')),
                  const SizedBox(height: 16),
                  const TextField(decoration: InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 16),
                  const TextField(decoration: InputDecoration(labelText: 'Phone')),
                  const SizedBox(height: 16),
                  const TextField(decoration: InputDecoration(labelText: 'Address')),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(child: TextField(decoration: InputDecoration(labelText: 'City'))),
                      SizedBox(width: 16),
                      Expanded(child: TextField(decoration: InputDecoration(labelText: 'State'))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(child: TextField(decoration: InputDecoration(labelText: 'Pincode'))),
                      SizedBox(width: 16),
                      Expanded(child: TextField(decoration: InputDecoration(labelText: 'Country'))),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text('Payment Options', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    children: const [
                      Chip(label: Text('UPI')),
                      Chip(label: Text('Credit / Debit Card')),
                      Chip(label: Text('Net Banking')),
                      Chip(label: Text('Cash on Delivery')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Order Summary', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 18),
                  Text('Subtotal: ₹${store.subtotal.toStringAsFixed(0)}'),
                  const SizedBox(height: 8),
                  Text('Shipping: ₹${store.shipping.toStringAsFixed(0)}'),
                  const SizedBox(height: 8),
                  Text('Discount: -₹${store.discount.toStringAsFixed(0)}'),
                  const SizedBox(height: 14),
                  const Divider(),
                  Text('Total: ₹${store.total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 18),
                  FilledButton(onPressed: () {}, child: const Text('Place Order')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
