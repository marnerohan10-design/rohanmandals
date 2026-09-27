import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ArtImage extends StatelessWidget {
  final String source;
  final BoxFit fit;
  final double? height;
  final double? width;

  const ArtImage({
    super.key,
    required this.source,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isRemote = source.startsWith('http');
    final image =
      isRemote
        ? Image.network(source, fit: fit, height: height, width: width)
        : SvgPicture.asset(source, fit: fit, height: height, width: width);

    return image;
  }
}
