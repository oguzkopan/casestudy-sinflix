import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sin_flix/app/app_router.dart';
import 'package:sin_flix/core/di/injector.dart';

import 'package:sin_flix/features/shell/presentation/cubit/shell_cubit.dart';

class ShellPage extends StatelessWidget {
  final Widget child;
  const ShellPage({super.key, required this.child});

  static final List<String> _pageKeys = [
    AppRouter.homePath,
    AppRouter.profilePath,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ShellCubit>(),
      child: Scaffold(
        body: child,
        bottomNavigationBar: BlocBuilder<ShellCubit, int>(
          builder: (context, currentIndex) {
            return BottomNavigationBar(
              currentIndex: _calculateSelectedIndex(context),
              onTap: (index) {
                context.read<ShellCubit>().changeTab(index);
                context.go('${AppRouter.shellPath}${_pageKeys[index]}');
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore_outlined),
                  activeIcon: Icon(Icons.explore),
                  label: 'Keşfet',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.routerDelegate.currentConfiguration.uri.toString();
    if (location.startsWith(AppRouter.shellPath + AppRouter.homePath)) {
      return 0;
    }
    if (location.startsWith(AppRouter.shellPath + AppRouter.profilePath)) {
      return 1;
    }
    return 0;
  }
}