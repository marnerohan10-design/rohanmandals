import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rohanmandalas/models/product.dart';
import 'package:rohanmandalas/providers/store_provider.dart';
import 'package:rohanmandalas/theme/app_theme.dart';
import 'package:rohanmandalas/widgets/art_image.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenShop;
  final VoidCallback onOpenCustom;
  final ValueChanged<Product> onOpenProduct;

  const HomeScreen({
    super.key,
    required this.onOpenShop,
    required this.onOpenCustom,
    required this.onOpenProduct,
  });

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();
    final featured = store.products.where((product) => product.featured).take(6).toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        _HeroSection(
          onOpenShop: onOpenShop,
          onOpenCustom: onOpenCustom,
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SectionHeader(
            title: 'Explore the Collection',
            subtitle: 'Curated pieces for mindful living',
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: featured.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (_, index) {
              final product = featured[index];
              return ProductCard(
                product: product,
                onPressed: () => onOpenProduct(product),
              );
            },
          ),
        ),
        const SizedBox(height: 36),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _ArtistIntro(),
        ),
        const SizedBox(height: 36),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _WhyMandala(),
        ),
        const SizedBox(height: 36),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _CustomMandalaCTA(
            onOpenCustom: onOpenCustom,
          ),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  final VoidCallback onOpenShop;
  final VoidCallback onOpenCustom;

  const _HeroSection({
    required this.onOpenShop,
    required this.onOpenCustom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [
            AppTheme.plum.withValues(alpha: 0.94),
            AppTheme.rust.withValues(alpha: 0.92),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.plum.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'ROHAN\'S MANDALA',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Art That Begins at the Center.',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 56,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Discover handcrafted Mandala artworks created with patience, symmetry, and imagination.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.84),
                    fontSize: 18,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 26),
                Wrap(
                  spacing: 14,
                  runSpacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: onOpenShop,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.gold,
                        foregroundColor: AppTheme.plum,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text('Explore Collection'),
                    ),
                    OutlinedButton(
                      onPressed: onOpenCustom,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white70),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text('Create Your Custom Mandala'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  height: 560,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1515405295579-ba7b45403062?auto=format&fit=crop&w=1200&q=80',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.35)],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        left: 24,
                        right: 24,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.star, color: AppTheme.gold),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Handcrafted in limited editions for conscious living',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 34,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.mutedText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onPressed;

  const ProductCard({
    super.key,
    required this.product,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFEDE5DC)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: ArtImage(
                source: product.images.first,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => store.toggleWishlist(product.id),
                        icon: Icon(
                          store.isWishlisted(product.id) ? Icons.favorite : Icons.favorite_border,
                          color: store.isWishlisted(product.id) ? AppTheme.rust : AppTheme.plum,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppTheme.gold, size: 16),
                      const SizedBox(width: 4),
                      Text(product.rating.toStringAsFixed(1)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 22),
                      ),
                      FilledButton(
                        onPressed: () => store.addToCart(product),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.plum,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Add to Cart'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArtistIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=700&q=80',
              height: 220,
              width: 220,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meet the Artist',
                  style: theme.textTheme.headlineMedium?.copyWith(fontSize: 34),
                ),
                const SizedBox(height: 12),
                Text(
                  'Every Mandala begins with a single point. For Rohan, that point becomes a journey of patience, geometry, creativity, and self-expression.',
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.7),
                ),
                const SizedBox(height: 18),
                Text(
                  'Rohan is a visual artist and spiritual creator whose work celebrates symmetry, memory, and healing. His art is drawn by hand with an intention to slow the mind and invite reflection.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: AppTheme.mutedText, height: 1.7),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.plum,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: const Text('Read My Story'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhyMandala extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'title': 'Handmade',
        'desc': 'Every artwork is carefully created by hand.',
      },
      {
        'title': 'Original',
        'desc': 'Unique designs created by the artist.',
      },
      {
        'title': 'Custom',
        'desc': 'Personalized Mandalas created according to customer requirements.',
      },
      {
        'title': 'Crafted With Patience',
        'desc': 'Every line and pattern is created with attention to detail.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Why Rohan\'s Mandala?',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 34),
        ),
        const SizedBox(height: 22),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (_, index) {
            final item = features[index];
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFEDE5DC)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '0${index + 1} — ${item['title']}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item['desc']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedText, height: 1.6),
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

class _CustomMandalaCTA extends StatelessWidget {
  final VoidCallback onOpenCustom;

  const _CustomMandalaCTA({required this.onOpenCustom});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [const Color(0xFFF6EDE2), AppTheme.parchment],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Have an Idea in Your Mind?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  'Let me turn your idea into a Mandala.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.mutedText),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onOpenCustom,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.plum,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: const Text('Request Custom Artwork'),
          ),
        ],
      ),
    );
  }
}
