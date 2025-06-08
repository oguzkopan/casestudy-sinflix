import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sin_flix/core/constants/app_assets.dart';
import 'package:sin_flix/core/theme/app_colors.dart';
import 'package:sin_flix/core/widgets/asset_icon.dart';
import '../../data/film.dart';
import '../cubit/liked_cubit.dart';

class FilmCard extends StatelessWidget {
  const FilmCard({super.key, required this.film});
  final Film film;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        /* poster ------------------------------------------------------------ */
        Image.network(film.imageUrl, fit: BoxFit.cover),

        /* gradient fade bottom -------------------------------------------- */
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black54, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        /* info ------------------------------------------------------------- */
        Positioned(
          left: 24,
          right: 24,
          bottom: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(film.title, style: text.titleLarge),
              const SizedBox(height: 4),
              Text(
                film.description,
                style: text.bodyMedium?.copyWith(color: AppColors.lightGrey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        /* like button ------------------------------------------------------ */
        Positioned(
          right: 24,
          bottom: 180,
          child: BlocBuilder<LikedCubit, Set<String>>(
            builder: (context, liked) {
              final isLiked = liked.contains(film.id);
              return GestureDetector(
                onTap: () => context.read<LikedCubit>().toggle(film.id),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: AssetIcon(
                      AppAssets.like,
                      size: 24,
                      color:
                      isLiked ? AppColors.primaryRed : AppColors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
