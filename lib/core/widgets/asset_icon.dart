import 'package:flutter/material.dart';

/// Small monochrome icon that can be tinted with [color].
/// Default size is **14×14 px** – much smaller than before.
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
  Widget build(BuildContext context) => Image.asset(
    path,
    width: size ?? 14,   // ↓ smaller default
    height: size ?? 14,
    fit: BoxFit.contain,
    color: color,
    colorBlendMode: BlendMode.srcIn,
  );
}
