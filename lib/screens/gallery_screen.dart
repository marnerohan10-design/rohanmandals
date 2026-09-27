import 'package:flutter/material.dart';
import 'package:rohanmandalas/data/asset_catalog.dart';
import 'package:rohanmandalas/widgets/art_image.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: ArtAssetCatalog.all.length,
      itemBuilder: (_, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: ArtImage(source: ArtAssetCatalog.all[index], fit: BoxFit.cover),
        );
      },
    );
  }
}
