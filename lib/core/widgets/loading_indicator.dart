import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sin_flix/core/constants/app_assets.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  const LoadingIndicator({super.key, this.size = 100.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Lottie.asset(
          AppAssets.loadingLottie,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}