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
      appBar: AppBar(
        title: const Text('ROHAN\'S MANDALA', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.2)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () => setState(() => _selectedIndex = 8),
            icon: Badge(
              label: Text(store.wishlist.length.toString()),
              child: const Icon(Icons.favorite_border),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _selectedIndex = 9),
            icon: Badge(
              label: Text(store.cartCount.toString()),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
        ],
      ),
      body: isProductSelected
          ? ProductDetailScreen(product: _selectedProduct!)
          : switch (_selectedIndex) {
              0 => HomeScreen(
                  onOpenShop: () => setState(() => _selectedIndex = 1),
                  onOpenCustom: () => setState(() => _selectedIndex = 3),
                  onOpenProduct: (product) => setState(() => _selectedProduct = product),
                ),
              1 => ShopScreen(
                  onOpenProduct: (product) => setState(() => _selectedProduct = product),
                ),
              2 => const CollectionsScreen(),
              3 => const CustomArtScreen(),
              4 => const AboutScreen(),
              5 => const GalleryScreen(),
              6 => const ContactScreen(),
              8 => WishlistScreen(onOpenProduct: (product) => setState(() => _selectedProduct = product)),
              9 => const CartScreen(),
              10 => const CheckoutScreen(),
              _ => const Center(child: Text('Page coming soon')),
            },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex >= 0 && _selectedIndex <= 6 ? _selectedIndex : 0,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
            _selectedProduct = null;
          });
        },
        destinations: _navItems
            .map((item) => NavigationDestination(label: item.label, icon: Icon(item.icon)))
            .toList(),
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
