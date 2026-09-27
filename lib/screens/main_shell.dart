import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rohanmandalas/models/product.dart';
import 'package:rohanmandalas/providers/store_provider.dart';
import 'package:rohanmandalas/screens/about_screen.dart';
import 'package:rohanmandalas/screens/cart_screen.dart';
import 'package:rohanmandalas/screens/checkout_screen.dart';
import 'package:rohanmandalas/screens/collections_screen.dart';
import 'package:rohanmandalas/screens/contact_screen.dart';
import 'package:rohanmandalas/screens/custom_art_screen.dart';
import 'package:rohanmandalas/screens/gallery_screen.dart';
import 'package:rohanmandalas/screens/home_screen.dart';
import 'package:rohanmandalas/screens/product_detail_screen.dart';
import 'package:rohanmandalas/screens/shop_screen.dart';
import 'package:rohanmandalas/screens/wishlist_screen.dart';
import 'package:rohanmandalas/theme/app_theme.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  Product? _selectedProduct;

  final List<NavigationItem> _navItems = const [
    NavigationItem(label: 'Home', icon: Icons.home_outlined),
    NavigationItem(label: 'Shop', icon: Icons.shopping_bag_outlined),
    NavigationItem(label: 'Collections', icon: Icons.collections_outlined),
    NavigationItem(label: 'Custom Art', icon: Icons.palette_outlined),
    NavigationItem(label: 'About', icon: Icons.info_outline),
    NavigationItem(label: 'Gallery', icon: Icons.image_outlined),
    NavigationItem(label: 'Contact', icon: Icons.mail_outline),
  ];

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();
    final isProductSelected = _selectedProduct != null;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 68),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder:
                  (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.02, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
              child:
                  isProductSelected
                      ? ProductDetailScreen(
                        key: ValueKey(_selectedProduct!.id),
                        product: _selectedProduct!,
                      )
                      : switch (_selectedIndex) {
                        0 => HomeScreen(
                          key: const ValueKey('home'),
                          onOpenShop: () => setState(() => _selectedIndex = 1),
                          onOpenCustom:
                              () => setState(() => _selectedIndex = 3),
                          onOpenProduct:
                              (product) =>
                                  setState(() => _selectedProduct = product),
                        ),
                        1 => ShopScreen(
                          key: const ValueKey('shop'),
                          onOpenProduct:
                              (product) =>
                                  setState(() => _selectedProduct = product),
                        ),
                        2 => const CollectionsScreen(
                          key: ValueKey('collections'),
                        ),
                        3 => const CustomArtScreen(key: ValueKey('custom-art')),
                        4 => const AboutScreen(key: ValueKey('about')),
                        5 => const GalleryScreen(key: ValueKey('gallery')),
                        6 => const ContactScreen(key: ValueKey('contact')),
                        8 => WishlistScreen(
                          key: const ValueKey('wishlist'),
                          onOpenProduct:
                              (product) =>
                                  setState(() => _selectedProduct = product),
                        ),
                        9 => const CartScreen(key: ValueKey('cart')),
                        10 => const CheckoutScreen(key: ValueKey('checkout')),
                        _ => const Center(
                          key: ValueKey('coming-soon'),
                          child: Text('Page coming soon'),
                        ),
                      },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  InkWell(
                    onTap:
                        () => setState(() {
                          _selectedIndex = 0;
                          _selectedProduct = null;
                        }),
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.blur_circular,
                            color: AppTheme.rust,
                            size: 22,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'ROHAN / MANDALA',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Wishlist',
                    onPressed: () => setState(() => _selectedIndex = 8),
                    icon: Badge(
                      label: Text(store.wishlist.length.toString()),
                      child: const Icon(Icons.favorite_border),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Cart',
                    onPressed: () => setState(() => _selectedIndex = 9),
                    icon: Badge(
                      label: Text(store.cartCount.toString()),
                      child: const Icon(Icons.shopping_bag_outlined),
                    ),
                  ),
                  PopupMenuButton<int>(
                    tooltip: 'Open menu',
                    icon: const Icon(Icons.menu_rounded),
                    onSelected:
                        (index) => setState(() {
                          _selectedIndex = index;
                          _selectedProduct = null;
                        }),
                    itemBuilder:
                        (context) => [
                          for (var index = 0; index < _navItems.length; index++)
                            PopupMenuItem(
                              value: index,
                              child: Row(
                                children: [
                                  Icon(_navItems[index].icon, size: 19),
                                  const SizedBox(width: 12),
                                  Text(_navItems[index].label),
                                ],
                              ),
                            ),
                        ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: const SizedBox.shrink(),
    );
  }
}

class NavigationItem {
  final String label;
  final IconData icon;

  const NavigationItem({required this.label, required this.icon});
}
