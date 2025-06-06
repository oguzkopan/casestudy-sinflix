import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sin_flix/core/constants/app_assets.dart';
import 'package:sin_flix/core/theme/app_colors.dart';
import 'package:sin_flix/features/auth/presentation/bloc/auth_bloc.dart';

/// Shows the splash logo full-screen for 3 s on **every** launch,
/// then lets GoRouter redirect according to the latest `AuthBloc` state.
///
/// • Dispatches `AuthStatusChecked` in `initState()` (only once)
/// • Uses `BoxFit.cover` so the PNG fills the entire viewport on any device
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Kick-off the auth-status check. GoRouter will react to the state change.
    context.read<AuthBloc>().add(AuthStatusChecked());

    // After 3 s we simply rebuild; GoRouter’s redirect logic will already
    // have moved us away from this page if needed.
    Timer(const Duration(seconds: 10), () {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.asset(AppAssets.splashLogo),
        ),
      ),
    );
  }
}
