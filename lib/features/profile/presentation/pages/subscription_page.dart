// lib/features/profile/presentation/pages/subscription_page.dart
import 'package:flutter/material.dart';
import 'package:sin_flix/core/constants/app_assets.dart';   // ← put the PNG path there
import 'package:sin_flix/core/theme/app_colors.dart';


class SubscriptionPage extends StatelessWidget {
  static const routePath = '/subscription';

  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SizedBox.expand(               // fills all available space
        child: FittedBox(
          fit: BoxFit.cover,               // scale-and-crop like in Figma
          child: Image(
            image: AssetImage(AppAssets.subscription), // e.g. 'assets/images/subscription.png'
          ),
        ),
      ),
    );
  }
}
