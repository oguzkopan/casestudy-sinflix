// lib/features/auth/presentation/pages/profile_photo_add_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sin_flix/core/constants/app_assets.dart';
import 'package:sin_flix/core/theme/app_colors.dart';
import 'package:sin_flix/core/widgets/asset_icon.dart';
import 'package:sin_flix/core/widgets/custom_button.dart';
import 'package:sin_flix/features/auth/presentation/bloc/auth_bloc.dart';

class ProfilePhotoAddPage extends StatefulWidget {
  const ProfilePhotoAddPage({super.key});

  @override
  State<ProfilePhotoAddPage> createState() => _ProfilePhotoAddPageState();
}

class _ProfilePhotoAddPageState extends State<ProfilePhotoAddPage> {
  File? _file;
  final _picker = ImagePicker();

  Future<void> _pick() async {
    final f = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (f != null) setState(() => _file = File(f.path));
  }

  void _continue() {
    final bloc = context.read<AuthBloc>();
    _file != null
        ? bloc.add(AuthPhotoUploadRequested(imageFile: _file!))
        : bloc.add(AuthPhotoUploadSkipped());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              /* ---------------- header row ---------------- */
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlack,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.lightGrey.withOpacity(.4),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const AssetIcon(AppAssets.backIcon),
                    ),
                  ),
                  const Spacer(),
                  Text('Profil Detayı',
                      style: Theme.of(context).textTheme.labelLarge),
                  const Spacer(flex: 2),
                ],
              ),
              const SizedBox(height: 32),

              /* -------------- headline & blurb ------------- */
              Text('Fotoğraflarınızı Yükleyin',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'Resources aut incentivize relaxation floor loss cc.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.lightGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              /* -------------- square picker ------------- */
              GestureDetector(
                onTap: _pick,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.lightGrey.withOpacity(.3),
                    ),
                    image: _file != null
                        ? DecorationImage(
                        image: FileImage(_file!), fit: BoxFit.cover)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: _file == null
                      ? const AssetIcon(AppAssets.plusIcon)
                      : null,
                ),
              ),

              /* ---- spacer pushes button to bottom ---- */
              const Spacer(),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (_, s) => CustomButton(
                  text: 'Devam Et',
                  isLoading: s is AuthLoading,
                  onPressed: _continue,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
