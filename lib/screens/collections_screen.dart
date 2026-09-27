import 'package:flutter/material.dart';
import 'package:rohanmandalas/theme/app_theme.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final collections = [
      {'name': 'Original Mandala Art', 'count': '12 pieces', 'image': 'https://images.unsplash.com/photo-1515405295579-ba7b45403062?auto=format&fit=crop&w=900&q=80'},
      {'name': 'Framed Mandalas', 'count': '08 pieces', 'image': 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=900&q=80'},
      {'name': 'Mini Mandalas', 'count': '16 pieces', 'image': 'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?auto=format&fit=crop&w=900&q=80'},
      {'name': 'Digital Mandala Art', 'count': '09 pieces', 'image': 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=900&q=80'},
      {'name': 'Custom Mandalas', 'count': 'On request', 'image': 'https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13?auto=format&fit=crop&w=900&q=80'},
      {'name': 'Gift Collection', 'count': 'Thoughtful picks', 'image': 'https://images.unsplash.com/photo-1493246507139-91e8fad9978e?auto=format&fit=crop&w=900&q=80'},
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Collections', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 42)),
        const SizedBox(height: 20),
        GridView.builder(
          itemCount: collections.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 18,
            crossAxisSpacing: 18,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (_, index) {
            final item = collections[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Image.network(item['image']!, height: 220, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['name']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text(item['count']!, style: TextStyle(color: AppTheme.mutedText)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
