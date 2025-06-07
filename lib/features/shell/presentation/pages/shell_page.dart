import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:sin_flix/app/app_router.dart';
import 'package:sin_flix/features/shell/presentation/cubit/shell_cubit.dart';

class ShellPage extends StatelessWidget {
  const ShellPage({super.key, required this.child});
  final Widget child;

  static const _paths = [
    AppRouter.homePath,
    AppRouter.profilePath,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // ⬇️ build the cubit inline – no GetIt lookup needed
      create: (_) => ShellCubit(),
      child: Scaffold(
        body: child,
        bottomNavigationBar: BlocBuilder<ShellCubit, int>(
          builder: (context, _) {
            return BottomNavigationBar(
              currentIndex: _selected(context),
              onTap: (i) {
                context.read<ShellCubit>().changeTab(i);
                context.go(_paths[i]);         // '/home' or '/profile'
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

  int _selected(BuildContext context) {
    final loc = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .uri
        .toString();
    return loc.startsWith(AppRouter.profilePath) ? 1 : 0;
  }
}
