import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sin_flix/core/theme/app_colors.dart';
import 'package:sin_flix/core/widgets/custom_button.dart';
import 'package:sin_flix/features/auth/presentation/bloc/auth_bloc.dart';

class ProfilePhotoAddPage extends StatefulWidget {
  const ProfilePhotoAddPage({super.key});

  @override
  State<ProfilePhotoAddPage> createState() => _ProfilePhotoAddPageState();
}

class _ProfilePhotoAddPageState extends State<ProfilePhotoAddPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _continueAction() {
    if (_imageFile != null) {
      context.read<AuthBloc>().add(AuthPhotoUploadRequested(imageFile: _imageFile!));
    } else {
      context.read<AuthBloc>().add(AuthPhotoUploadSkipped());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profil Fotoğrafı Ekle'),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text("Fotoğraf Yüklenemedi: ${state.message}"),
                  backgroundColor: AppColors.primaryRed));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Fotoğrafınızı Yükleyin',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Resources aut exercitus obdormiverit relaxation floor isis cc.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.lightGrey),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.lightGrey.withOpacity(0.5), width: 1),
                          image: _imageFile != null
                              ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                              : null,
                        ),
                        child: _imageFile == null
                            ? const Icon(Icons.add_a_photo_outlined, color: AppColors.lightGrey, size: 50)
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return CustomButton(
                    text: 'Devam Et',
                    onPressed: _continueAction,
                    isLoading: state is AuthLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}