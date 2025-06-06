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
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() =>
      setState(() => _obscureText = !_obscureText);

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
    final textTheme   = Theme.of(context).textTheme;
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenHeight * .05),
                  Image.asset(AppAssets.appLogo, height: 50),
                  SizedBox(height: screenHeight * .05),

                  // Headline + sub-text
                  Text('Merhabalar',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    'Tempus varius ei vitae interdum id elementum tristique sed fend elt.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium
                        ?.copyWith(color: AppColors.lightGrey),
                  ),
                  SizedBox(height: screenHeight * .04),

                  // Email
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'E-Posta',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'E-posta boş olamaz';
                      if (!v.contains('@') || !v.contains('.')) {
                        return 'Geçerli bir e-posta girin';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Şifre',
                    obscureText: _obscureText,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Şifre boş olamaz';
                      if (v.length < 6) return 'Şifre en az 6 karakter olmalı';
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {}, // TODO: forgot-password flow
                      child: const Text('Şifremi Unuttum'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (_, state) => CustomButton(
                      text: 'Giriş Yap',
                      isLoading: state is AuthLoading,
                      onPressed: _login,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Social buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialIcon(AppAssets.googleIcon, onTap: () {}),
                      const SizedBox(width: 20),
                      _SocialIcon(AppAssets.appleIcon,  onTap: () {}),
                      const SizedBox(width: 20),
                      _SocialIcon(AppAssets.facebookIcon, onTap: () {}),
                    ],
                  ),

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

  /// Rounded-square 56×56 icon
  Widget _SocialIcon(String asset, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(asset, width: 24, height: 24),
      ),
    );
  }

  Widget _buildRegisterPrompt(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColors.lightGrey),
        text: 'Bir hesabın yok mu? ',
        children: [
          TextSpan(
            text: 'Kayıt Ol',
            style: const TextStyle(
                color: AppColors.primaryRed, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.push(AppRouter.registerPath),
          ),
        ],
      ),
    );
  }
}
