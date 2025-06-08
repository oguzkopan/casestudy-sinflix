// lib/features/auth/presentation/pages/login_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:sin_flix/app/app_router.dart';
import 'package:sin_flix/core/constants/app_assets.dart';
import 'package:sin_flix/core/theme/app_colors.dart';
import 'package:sin_flix/core/widgets/asset_icon.dart';
import 'package:sin_flix/core/widgets/custom_button.dart';
import 'package:sin_flix/core/widgets/custom_text_field.dart';
import 'package:sin_flix/features/auth/presentation/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey          = GlobalKey<FormState>();
  final _emailController  = TextEditingController();
  final _passwordController = TextEditingController();
  bool  _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggle() => setState(() => _obscure = !_obscure);

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(AuthLoginRequested(
        email:    _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (_, s) {
          if (s is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(s.message), backgroundColor: AppColors.primaryRed),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: h * .05),
                  Image.asset(AppAssets.appLogo, height: 50),
                  SizedBox(height: h * .05),

                  Text('Merhabalar',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(
                    'Tempus varius ei vitae interdum id tortor elementum tristique eleifend at.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: h * .04),

                  CustomTextField(
                    controller: _emailController,
                    hintText: 'E-Posta',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const AssetIcon(AppAssets.mailIcon),
                    validator: (v) => (v?.contains('@') ?? false) ? null : 'Geçerli e-posta girin',
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Şifre',
                    obscureText: _obscure,
                    prefixIcon: const AssetIcon(AppAssets.lockIcon),
                    suffixIcon: GestureDetector(
                      onTap: _toggle,
                      child: AssetIcon(_obscure ? AppAssets.eyeClosed : AppAssets.eyeOpen),
                    ),
                    validator: (v) => (v != null && v.length >= 6) ? null : 'En az 6 karakter',
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: const Text('Şifremi unuttum'),
                      onPressed: () {/* TODO */},
                    ),
                  ),
                  const SizedBox(height: 8),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (_, s) => CustomButton(
                      text: 'Giriş Yap',
                      isLoading: s is AuthLoading,
                      onPressed: _submit,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _SocialRow(),

                  const SizedBox(height: 32),
                  _BottomPrompt(
                    question: 'Bir hesabın yok mu? ',
                    action: 'Kayıt Ol',
                    onTap: () => context.push(AppRouter.registerPath),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ------------------------- shared bits ------------------------------- */

class _SocialRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _SquareBtn(AppAssets.googleIcon),
      const SizedBox(width: 20),
      _SquareBtn(AppAssets.appleIcon),
      const SizedBox(width: 20),
      _SquareBtn(AppAssets.facebookIcon),
    ],
  );
}

class _SquareBtn extends StatelessWidget {
  const _SquareBtn(this.icon, {this.onTap});
  final String icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Image.asset(icon, width: 24, height: 24),
    ),
  );
}

class _BottomPrompt extends StatelessWidget {
  const _BottomPrompt(
      {required this.question, required this.action, required this.onTap});
  final String question, action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: AppColors.lightGrey),
      text: question,
      children: [
        TextSpan(
          text: action,
          style: const TextStyle(
              color: AppColors.primaryRed, fontWeight: FontWeight.w700),
          recognizer: TapGestureRecognizer()..onTap = onTap,
        )
      ],
    ),
  );
}
