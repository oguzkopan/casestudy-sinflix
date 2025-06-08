// lib/features/profile/presentation/pages/profile_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sin_flix/core/constants/app_assets.dart';
import 'package:sin_flix/core/theme/app_colors.dart';
import 'package:sin_flix/core/widgets/custom_button.dart';
import 'package:sin_flix/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sin_flix/features/home/data/film.dart';
import 'package:sin_flix/features/home/presentation/cubit/liked_cubit.dart';
import 'package:sin_flix/features/profile/presentation/pages/subscription_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static const routePath = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  final _picker = ImagePicker();
  File? _newAvatar;

  late Future<List<Film>> _filmsFuture; // cache the JSON once

  @override
  void initState() {
    super.initState();
    _filmsFuture = Film.loadFromAsset();
  }

  @override
  bool get wantKeepAlive => true;

  /* ───────────────── helpers ───────────────── */
  Future<void> _pickPhoto() async {
    final img =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (img == null) return;
    setState(() => _newAvatar = File(img.path));
    context
        .read<AuthBloc>()
        .add(AuthPhotoUploadRequested(imageFile: _newAvatar!));
  }

  Future<void> _refresh() async {
    // reload the JSON & let FutureBuilder run again
    _filmsFuture = Film.loadFromAsset();
    setState(() {});
  }

  void _openSubscriptionSheet() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,      // 👈  <-- THIS is the key line
      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      builder: (_) => const SafeArea(    // keeps the sheet above the home-indicator
        top: false,                // (we only care about the bottom inset here)
        child: FractionallySizedBox(
          heightFactor: .90,       // up to 90 % of the screen – tweak as you like
          child: ClipRRect(
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(24)),
            child: SubscriptionPage(),
          ),
        ),
      ),
    );
  }


  /* ───────────────── UI ───────────────── */
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: _buildAppBar(t),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (_, authState) {
          if (authState is! AuthAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = authState.user;

          // listen to *every* change of LikedCubit
          return BlocBuilder<LikedCubit, Set<String>>(
            builder: (_, likedIds) => FutureBuilder<List<Film>>(
              future: _filmsFuture,
              builder: (_, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final likedFilms =
                snap.data!.where((f) => likedIds.contains(f.id)).toList();

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      _userCardSliver(user),
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                      _sectionTitleSliver(t),
                      likedFilms.isEmpty
                          ? _emptyStateSliver(t)
                          : _filmsGridSliver(likedFilms),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /* ---- small sliver helpers ---- */
  SliverPadding _userCardSliver(user) => SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    sliver: SliverToBoxAdapter(
      child: _UserCard(
        userName: user.name,
        userId: user.id,
        avatarUrl: user.photoUrl,
        localAvatar: _newAvatar,
        onAddPhoto: _pickPhoto,
      ),
    ),
  );

  SliverPadding _sectionTitleSliver(TextTheme t) => SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    sliver: SliverToBoxAdapter(
      child: Text('Beğendiğim Filmler',
          style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
    ),
  );

  SliverFillRemaining _emptyStateSliver(TextTheme t) => SliverFillRemaining(
    hasScrollBody: false,
    child: Center(
      child: Text('Henüz film beğenmediniz.',
          style: t.bodySmall?.copyWith(color: AppColors.lightGrey)),
    ),
  );

  SliverPadding _filmsGridSliver(List<Film> films) => SliverPadding(
    padding: const EdgeInsets.all(16),
    sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: .62,
      ),
      delegate: SliverChildBuilderDelegate(
            (_, i) => _FilmTile(film: films[i]),
        childCount: films.length,
      ),
    ),
  );

  /* ---- App-bar ---- */
  PreferredSize _buildAppBar(TextTheme t) => PreferredSize(
    preferredSize: const Size.fromHeight(56),
    child: SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Text('Profil Detayı',
                  textAlign: TextAlign.center,
                  style: t.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ),
            IconButton(
              splashRadius: 22,
              icon: const Icon(Icons.logout, size: 20),
              onPressed: () =>
                  context.read<AuthBloc>().add(AuthLogoutRequested()),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: _openSubscriptionSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Image.asset(AppAssets.proIcon,
                        width: 16, height: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    const Text('Sınırlı Teklif',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/* ─────────── USER CARD ─────────── */
class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.userName,
    required this.userId,
    required this.avatarUrl,
    this.localAvatar,
    required this.onAddPhoto,
  });

  final String userName;
  final String userId;
  final String? avatarUrl;
  final File? localAvatar;
  final VoidCallback onAddPhoto;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Row(
      children: [
        /* avatar */
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryRed,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: localAvatar != null
                  ? FileImage(localAvatar!)
                  : (avatarUrl != null && avatarUrl!.isNotEmpty)
                  ? NetworkImage(avatarUrl!)
                  : const AssetImage(AppAssets.placeholder)
              as ImageProvider,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName,
                  style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w400)),
              const SizedBox(height: 2),
              Text('ID: $userId',
                  style: t.bodySmall?.copyWith(color: AppColors.lightGrey)),
            ],
          ),
        ),
        SizedBox(
          width: 110,
          child: CustomButton.mini(
            text: 'Fotoğraf Ekle',
            onPressed: onAddPhoto,
          ),
        ),
      ],
    );
  }
}

/* ─────────── FILM TILE ─────────── */
class _FilmTile extends StatelessWidget {
  const _FilmTile({required this.film});
  final Film film;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            film.imageUrl,
            height: 140,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 6),
        Text(film.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        Text(film.studio,
            style: t.bodySmall?.copyWith(color: AppColors.lightGrey)),
      ],
    );
  }
}
