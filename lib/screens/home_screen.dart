import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rohanmandalas/data/asset_catalog.dart';
import 'package:rohanmandalas/models/product.dart';
import 'package:rohanmandalas/providers/store_provider.dart';
import 'package:rohanmandalas/theme/app_theme.dart';
import 'package:rohanmandalas/widgets/art_image.dart';

class HomeScreen extends StatefulWidget {
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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();
    final featured =
        store.products.where((product) => product.featured).take(4).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 850;
        return ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 48),
          children: [
            _Reveal(
              controller: _entranceController,
              child: _HeroSection(
                isWide: isWide,
                onOpenShop: widget.onOpenShop,
                onOpenCustom: widget.onOpenCustom,
              ),
            ),
            const SizedBox(height: 20),
            _Reveal(
              controller: _entranceController,
              delay: 0.18,
              child: const _StatsStrip(),
            ),
            const SizedBox(height: 54),
            _SectionHeading(
              eyebrow: 'WHAT I CREATE',
              title: 'Visual stories with a handmade center.',
              action: TextButton.icon(
                onPressed: widget.onOpenShop,
                icon: const Icon(Icons.arrow_outward, size: 17),
                label: const Text('View collection'),
              ),
            ),
            const SizedBox(height: 20),
            _Reveal(
              controller: _entranceController,
              delay: 0.28,
              child: _ServicesGrid(isWide: isWide),
            ),
            const SizedBox(height: 54),
            _SectionHeading(
              eyebrow: 'SELECTED WORK',
              title: 'A few pieces from the studio.',
              action: TextButton.icon(
                onPressed: widget.onOpenShop,
                icon: const Icon(Icons.arrow_outward, size: 17),
                label: const Text('See all work'),
              ),
            ),
            const SizedBox(height: 20),
            _Reveal(
              controller: _entranceController,
              delay: 0.38,
              child: _ProjectGrid(
                products: featured,
                isWide: isWide,
                onOpenProduct: widget.onOpenProduct,
              ),
            ),
            const SizedBox(height: 54),
            _Reveal(
              controller: _entranceController,
              delay: 0.48,
              child: _CommissionBanner(onOpenCustom: widget.onOpenCustom),
            ),
          ],
        );
      },
    );
  }
}

class _Reveal extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final Widget child;

  const _Reveal({
    required this.controller,
    required this.child,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(delay, 1, curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder:
          (context, child) => Opacity(
            opacity: animation.value,
            child: Transform.translate(
              offset: Offset(0, 24 * (1 - animation.value)),
              child: child,
            ),
          ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final bool isWide;
  final VoidCallback onOpenShop;
  final VoidCallback onOpenCustom;

  const _HeroSection({
    required this.isWide,
    required this.onOpenShop,
    required this.onOpenCustom,
  });

  @override
  Widget build(BuildContext context) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HANDCRAFTED MANDALA ART',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.rust,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Art that begins\nat the center.',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 0.98,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Original mandalas shaped by patience, symmetry, and the quiet beauty of intentional detail.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.mutedText,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: onOpenShop,
              icon: const Icon(Icons.arrow_outward, size: 17),
              label: const Text('Explore the work'),
            ),
            OutlinedButton(
              onPressed: onOpenCustom,
              child: const Text('Start a commission'),
            ),
          ],
        ),
      ],
    );

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: isWide ? 1.06 : 1.3,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ArtImage(source: ArtAssetCatalog.all[0], fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppTheme.plum.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),
            const Positioned(left: 18, bottom: 18, child: _ImageLabel()),
          ],
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.all(isWide ? 34 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.line),
      ),
      child:
          isWide
              ? Row(
                children: [
                  Expanded(child: text),
                  const SizedBox(width: 42),
                  Expanded(child: image),
                ],
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [text, const SizedBox(height: 28), image],
              ),
    );
  }
}

class _ImageLabel extends StatelessWidget {
  const _ImageLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        '01 / 30   COSMIC BLOOM',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip();

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('30+', 'Original works'),
      ('12+', 'Years of practice'),
      ('240+', 'Happy collectors'),
      ('01', 'Handmade process'),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: AppTheme.plum,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        runSpacing: 18,
        children:
            stats
                .map(
                  (stat) => SizedBox(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stat.$1,
                          style: const TextStyle(
                            color: AppTheme.gold,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stat.$2,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String eyebrow;
  final String title;
  final Widget action;

  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.rust,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
        ),
        action,
      ],
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  final bool isWide;
  const _ServicesGrid({required this.isWide});

  @override
  Widget build(BuildContext context) {
    final services = [
      (
        '01',
        'Original art',
        'One-of-one mandalas drawn and finished by hand.',
        Icons.blur_circular_outlined,
      ),
      (
        '02',
        'Custom pieces',
        'A personal composition built around your story.',
        Icons.auto_awesome_outlined,
      ),
      (
        '03',
        'Meaningful gifts',
        'Thoughtful artwork for spaces, rituals, and people.',
        Icons.card_giftcard_outlined,
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 3 : 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isWide ? 1.2 : 3.2,
      ),
      itemBuilder: (context, index) {
        final item = services[index];
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: index == 1 ? AppTheme.parchment : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.line),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item.$4, color: AppTheme.rust, size: 25),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.$1,
                      style: const TextStyle(
                        color: AppTheme.mutedText,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.$2,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 21),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.$3,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(height: 1.45),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProjectGrid extends StatelessWidget {
  final List<Product> products;
  final bool isWide;
  final ValueChanged<Product> onOpenProduct;

  const _ProjectGrid({
    required this.products,
    required this.isWide,
    required this.onOpenProduct,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 4 : 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: isWide ? 0.82 : 0.72,
      ),
      itemBuilder:
          (context, index) => _ProjectTile(
            product: products[index],
            asset: ArtAssetCatalog.all[index + 1],
            onPressed: () => onOpenProduct(products[index]),
          ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  final Product product;
  final String asset;
  final VoidCallback onPressed;

  const _ProjectTile({
    required this.product,
    required this.asset,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ArtImage(
                source: asset,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 19),
          ),
          Text(
            product.categoryLabel,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _CommissionBanner extends StatelessWidget {
  final VoidCallback onOpenCustom;
  const _CommissionBanner({required this.onOpenCustom});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: AppTheme.rust,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Have an idea in mind?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Let’s shape it into something personal.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: onOpenCustom,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.plum,
            ),
            child: const Text('Start a project'),
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
      borderRadius: BorderRadius.circular(16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ArtImage(
              source: product.images.first,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(fontSize: 21),
                          maxLines: 2,
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
                        ),
                      ),
                    ],
                  ),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppTheme.gold,
                        size: 16,
                      ),
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
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(fontSize: 22),
                      ),
                      FilledButton(
                        onPressed: () => store.addToCart(product),
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
