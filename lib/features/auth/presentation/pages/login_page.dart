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

/// ─────────────────────────────────────────────────────────────
/// LOGIN PAGE
/// ─────────────────────────────────────────────────────────────
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey      = GlobalKey<FormState>();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool  _obscure      = true;

  /* ───────────── helpers ───────────── */
  void _togglePwd() => setState(() => _obscure = !_obscure);

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email   : _emailCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  /* ───────────────────────── UI ───────────────────────── */
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (_, s) => s is AuthFailure,
        listener: (_, s) {
          _passwordCtrl.clear(); // keep e-mail, clear pwd
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text((s as AuthFailure).message),
              backgroundColor: AppColors.primaryRed,
            ),
          );
        },

        builder: (_, __) => SafeArea(
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
                    'Tempus varius ei vitae interdum id tortor elementum '
                        'tristique eleifend at.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: h * .04),

                  /* E-posta -------------------------------------------------- */
                  CustomTextField(
                    controller  : _emailCtrl,
                    hintText    : 'E-Posta',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon  : const AssetIcon(AppAssets.mailIcon),
                    validator   : (v) =>
                    (v?.contains('@') ?? false)
                        ? null
                        : 'Geçerli e-posta girin',
                  ),
                  const SizedBox(height: 16),

                  /* Şifre --------------------------------------------------- */
                  CustomTextField(
                    controller : _passwordCtrl,
                    hintText   : 'Şifre',
                    obscureText: _obscure,
                    prefixIcon : const AssetIcon(AppAssets.lockIcon),
                    suffixIcon : GestureDetector(
                      onTap : _togglePwd,
                      child : AssetIcon(
                        _obscure ? AppAssets.eyeClosed : AppAssets.eyeOpen,
                        size: 18,
                      ),
                    ),
                    validator: (v) =>
                    (v != null && v.length >= 6)
                        ? null
                        : 'En az 6 karakter',
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: const Text('Şifremi unuttum'),
                      onPressed: () {/* TODO */},
                    ),
                  ),
                  const SizedBox(height: 8),

                  /* submit -------------------------------------------------- */
                  CustomButton(
                    text     : 'Giriş Yap',
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 24),

                  const _SocialRow(),
                  const SizedBox(height: 32),

                  _BottomPrompt(
                    question: 'Bir hesabın yok mu? ',
                    action  : 'Kayıt Ol',
                    onTap   : () => context.push(AppRouter.registerPath),
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

class _SocialRow extends StatelessWidget {
  const _SocialRow();

  @override
  Widget build(BuildContext context) => const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _SquareBtn(AppAssets.googleIcon),
      SizedBox(width: 20),
      _SquareBtn(AppAssets.appleIcon),
      SizedBox(width: 20),
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
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Image.asset(icon, width: 20, height: 20),
    ),
  );
}

class _BottomPrompt extends StatelessWidget {
  const _BottomPrompt({
    required this.question,
    required this.action,
    required this.onTap,
  });

  final String      question;
  final String      action;
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
            color: AppColors.primaryRed,
            fontWeight: FontWeight.w700,
          ),
          recognizer: TapGestureRecognizer()..onTap = onTap,
        ),
      ],
    ),
  );
}
