import 'package:flutter/material.dart';

/// A reusable image-icon that can be colour-tinted with the [color] argument.
///
/// * We purposely keep [colorBlendMode] fixed to **srcIn** so the given colour
///   replaces every non-transparent pixel in the PNG – perfect for monochrome
///   glyphs exported from Figma.
class AssetIcon extends StatelessWidget {
  const AssetIcon(
      this.path, {
        super.key,
        this.size,
        this.color,
      });

  final String path;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: size ?? 16,
      height: size ?? 16,
      fit: BoxFit.contain,
      color: color,
      colorBlendMode: BlendMode.srcIn,
    );
  }
}
