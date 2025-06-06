import 'package:flutter/material.dart';
import 'package:sin_flix/core/constants/app_assets.dart';
import 'package:sin_flix/core/theme/app_colors.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: Center(
        child: Image.asset(
          AppAssets.splashLogo,
          width: MediaQuery.of(context).size.width * 0.6,
        ),
      ),
    );
  }
}