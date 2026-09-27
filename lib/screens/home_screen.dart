import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rohanmandalas/data/asset_catalog.dart';
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
    final featured =
        store.products.where((product) => product.featured).take(6).toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 60),
      children: [
        _ReferenceHero(onOpenShop: onOpenShop, onOpenCustom: onOpenCustom),
        const SizedBox(height: 44),
        const _SectionTitle(eyebrow: 'MY SERVICES', title: 'What I create'),
        const SizedBox(height: 18),
        const _Services(),
        const SizedBox(height: 42),
        Center(
          child: OutlinedButton.icon(
            onPressed: onOpenCustom,
            icon: const Icon(Icons.arrow_forward, size: 15),
            label: const Text('Start a project'),
          ),
        ),
        const SizedBox(height: 52),
        const _SectionTitle(
          eyebrow: 'MY PORTFOLIO',
          title: 'Selected mandalas',
        ),
        const SizedBox(height: 18),
        _PortfolioGrid(products: featured, onOpenProduct: onOpenProduct),
        const SizedBox(height: 50),
        _ContactBanner(onOpenCustom: onOpenCustom),
      ],
    );
  }
}

class _ReferenceHero extends StatelessWidget {
  final VoidCallback onOpenShop;
  final VoidCallback onOpenCustom;

  const _ReferenceHero({required this.onOpenShop, required this.onOpenCustom});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;
        final heroImage = Positioned(
          right: isWide ? 30 : 20,
          bottom: 0,
          child: SizedBox(
            width: isWide ? 300 : 190,
            height: isWide ? 365 : 230,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(100),
              ),
              child: ArtImage(
                source: ArtAssetCatalog.all[2],
                fit: BoxFit.cover,
              ),
            ),
          ),
        );

        return Container(
          margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          constraints: BoxConstraints(minHeight: isWide ? 390 : 470),
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: AppTheme.plum,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(92),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Stack(
            children: [
              if (isWide) heroImage,
              Positioned(
                left: isWide ? 38 : 24,
                top: 30,
                right: isWide ? 350 : 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HELLO, I\'M ROHAN',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.gold,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Mandala\nartist',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontSize: isWide ? 58 : 48,
                        height: 0.9,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Hand-drawn geometry, made personal.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 22),
                    FilledButton.icon(
                      onPressed: onOpenShop,
                      icon: const Icon(Icons.arrow_forward, size: 15),
                      label: const Text('View my work'),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: onOpenCustom,
                      child: const Text(
                        'Commission a piece',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isWide)
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 0,
                  child: SizedBox(height: 190, child: heroImage.child),
                ),
              const Positioned(
                right: 22,
                top: 22,
                child: Icon(Icons.auto_awesome, color: AppTheme.gold, size: 22),
              ),
              const Positioned(
                left: 22,
                bottom: 18,
                child: Text(
                  '01 / 30',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String eyebrow;
  final String title;

  const _SectionTitle({required this.eyebrow, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppTheme.charcoal,
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.underline,
              decorationColor: AppTheme.gold,
              decorationThickness: 3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 30,
              color: AppTheme.charcoal,
            ),
          ),
        ],
      ),
    );
  }
}

class _Services extends StatelessWidget {
  const _Services();

  @override
  Widget build(BuildContext context) {
    const services = [
      (Icons.grid_view_rounded, 'Original Art'),
      (Icons.palette_outlined, 'Custom Mandala'),
      (Icons.auto_awesome, 'Framed Pieces'),
      (Icons.card_giftcard_outlined, 'Art Gifts'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 720 ? 4 : 2;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              mainAxisExtent: 145,
            ),
            itemBuilder: (_, index) {
              final service = services[index];
              return Column(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.gold, width: 1.5),
                      color: AppTheme.parchment,
                    ),
                    child: Icon(service.$1, color: AppTheme.charcoal, size: 28),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    service.$2,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.charcoal,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _PortfolioGrid extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<Product> onOpenProduct;

  const _PortfolioGrid({required this.products, required this.onOpenProduct});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 760 ? 3 : 2;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 8,
              mainAxisSpacing: 18,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (_, index) {
              final product = products[index];
              return InkWell(
                onTap: () => onOpenProduct(product),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ArtImage(
                        source:
                            ArtAssetCatalog.all[(index + 8) %
                                ArtAssetCatalog.all.length],
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.charcoal,
                      ),
                    ),
                    Text(
                      product.categoryLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mutedText,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ContactBanner extends StatelessWidget {
  final VoidCallback onOpenCustom;

  const _ContactBanner({required this.onOpenCustom});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.parchment,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Have an idea? Let’s draw it together.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.charcoal,
                fontSize: 22,
              ),
            ),
          ),
          IconButton(
            onPressed: onOpenCustom,
            icon: const Icon(Icons.arrow_forward, color: AppTheme.charcoal),
          ),
        ],
      ),
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
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ArtImage(source: product.images.first, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => store.toggleWishlist(product.id),
                    icon: Icon(
                      store.isWishlisted(product.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: AppTheme.rust,
                      size: 18,
                    ),
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
