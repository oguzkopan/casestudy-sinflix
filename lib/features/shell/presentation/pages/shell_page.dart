import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:sin_flix/app/app_router.dart';
import 'package:sin_flix/core/constants/app_assets.dart';   // home.png, profile.png
import 'package:sin_flix/core/theme/app_colors.dart';
import '../cubit/shell_cubit.dart';

class ShellPage extends StatelessWidget {
  const ShellPage({super.key, required this.child});
  final Widget child;

  static const _destinations = [
    (path: AppRouter.homePath,    icon: AppAssets.home,    label: 'Anasayfa'),
    (path: AppRouter.profilePath, icon: AppAssets.profile, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShellCubit(),
      child: Scaffold(
        body: child,

        /* ---------- CUSTOM NAV ---------- */
        bottomNavigationBar: SafeArea(
          top: false,
          child: BlocBuilder<ShellCubit, int>(
            builder: (context, index) {
              return Container(
                height: 72,
                color: AppColors.primaryBlack,
                padding: const EdgeInsets.symmetric(horizontal: 24), // ⬅︎ edge insets
                child: Row(
                  children: [
                    // first pill
                    Expanded(
                      child: _NavButton(
                        selected: index == 0,
                        asset   : _destinations[0].icon,
                        label   : _destinations[0].label,
                        onTap   : () {
                          context.read<ShellCubit>().changeTab(0);
                          context.go(_destinations[0].path);
                        },
                      ),
                    ),

                    const SizedBox(width: 16),                     // ⬅︎ gap

                    // second pill
                    Expanded(
                      child: _NavButton(
                        selected: index == 1,
                        asset   : _destinations[1].icon,
                        label   : _destinations[1].label,
                        onTap   : () {
                          context.read<ShellCubit>().changeTab(1);
                          context.go(_destinations[1].path);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/* ---------------- NAV BUTTON ---------------- */
class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.selected,
    required this.asset,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final String asset;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryBlack,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: selected
                ? AppColors.white
                : AppColors.lightGrey.withOpacity(.25),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // centred icon + text
          children: [
            Image.asset(
              asset,
              width: 20,
              height: 20,
              color:
              selected ? AppColors.white : AppColors.lightGrey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color:
                selected ? AppColors.white : AppColors.lightGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
