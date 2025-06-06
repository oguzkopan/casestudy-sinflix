import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sin_flix/app/app_router.dart';
import 'package:sin_flix/core/constants/app_assets.dart';
import 'package:sin_flix/core/theme/app_colors.dart';
import 'package:sin_flix/core/widgets/custom_button.dart';
import 'package:sin_flix/core/widgets/custom_text_field.dart';
import 'package:sin_flix/features/auth/presentation/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthLoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.primaryRed));
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.05),
                  Image.asset(AppAssets.appLogo, height: 50),
                  SizedBox(height: screenHeight * 0.05),
                  Text(
                    'Merhabalar',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tempus varius ei vitae interdum id elementum tristique sedfend elt.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(color: AppColors.lightGrey),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'E-Posta',
                    prefixIcon: const Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'E-posta boş olamaz';
                      if (!value.contains('@') || !value.contains('.')) return 'Geçerli bir e-posta girin';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Şifre',
                    obscureText: _obscureText,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      onPressed: _togglePasswordVisibility,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Şifre boş olamaz';
                      if (value.length < 6) return 'Şifre en az 6 karakter olmalı';
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Şifremi Unuttum'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Giriş Yap',
                        onPressed: _login,
                        isLoading: state is AuthLoading,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSocialLoginButtons(context),
                  const SizedBox(height: 32),
                  _buildRegisterPrompt(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButtons(BuildContext context) {
    Widget socialButton(String assetPath, VoidCallback onPressed) {
      return InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            shape: BoxShape.circle,
          ),
          child: Image.asset(assetPath, height: 24, width: 24, color: AppColors.lightGrey),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        socialButton(AppAssets.googleIcon, () {}),
        const SizedBox(width: 20),
        socialButton(AppAssets.facebookIcon, () {}),
        const SizedBox(width: 20),
        socialButton(AppAssets.appleIcon, () {}),
      ],
    );
  }

  Widget _buildRegisterPrompt(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Bir hesabın yok mu? ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.lightGrey),
          children: <TextSpan>[
            TextSpan(
              text: 'Kayıt Ol',
              style: const TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()..onTap = () => context.push(AppRouter.registerPath),
            ),
          ],
        ),
      ),
    );
  }
}