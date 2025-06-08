// lib/features/auth/presentation/pages/register_page.dart
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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

/* ────────────────────────────────────────────────────────────── */

class _RegisterPageState extends State<RegisterPage> {
  final _formKey        = GlobalKey<FormState>();
  final _nameCtrl       = TextEditingController();
  final _emailCtrl      = TextEditingController();
  final _pwdCtrl        = TextEditingController();
  final _pwdConfirmCtrl = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _agree    = false;

  /* ------------ lifecycle ------------ */
  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    _pwdConfirmCtrl.dispose();
    super.dispose();
  }

  /* ------------ helpers -------------- */
  void _toggle1() => setState(() => _obscure1 = !_obscure1);
  void _toggle2() => setState(() => _obscure2 = !_obscure2);

  void _submit() {
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kullanıcı sözleşmesini kabul etmelisiniz.'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          name     : _nameCtrl.text.trim(),
          email    : _emailCtrl.text.trim(),
          password : _pwdCtrl.text.trim(),
          birthDate: '',                    // doğum tarihi alınmıyor
        ),
      );
    }
  }

  /* ------------ UI ------------------- */
  @override
  Widget build(BuildContext context) {
    final h  = MediaQuery.of(context).size.height;
    final th = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: h * .02),
                  Text('Hoşgeldiniz', textAlign: TextAlign.center, style: th.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    'Tempus varius ei vitae interdum id tortor elementum tristique eleifend at.',
                    textAlign: TextAlign.center,
                    style: th.bodyMedium?.copyWith(color: AppColors.lightGrey),
                  ),
                  SizedBox(height: h * .03),

                  /* Ad Soyad */
                  CustomTextField(
                    controller: _nameCtrl,
                    hintText  : 'Ad Soyad',
                    prefixIcon: const AssetIcon(AppAssets.nameIcon),
                    validator : (v) => (v?.isEmpty ?? true) ? 'Ad Soyad boş olamaz' : null,
                  ),
                  const SizedBox(height: 16),

                  /* E-posta */
                  CustomTextField(
                    controller : _emailCtrl,
                    hintText   : 'E-Posta',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon : const AssetIcon(AppAssets.mailIcon),
                    validator  : (v) =>
                    (v != null && v.contains('@') && v.contains('.'))
                        ? null : 'Geçerli e-posta girin',
                  ),
                  const SizedBox(height: 16),

                  /* Şifre */
                  CustomTextField(
                    controller : _pwdCtrl,
                    hintText   : 'Şifre',
                    obscureText: _obscure1,
                    prefixIcon : const AssetIcon(AppAssets.lockIcon),
                    suffixIcon : GestureDetector(
                      onTap : _toggle1,
                      child : AssetIcon(_obscure1 ? AppAssets.eyeClosed : AppAssets.eyeOpen),
                    ),
                    validator: (v) =>
                    (v != null && v.length >= 6) ? null : 'En az 6 karakter',
                  ),
                  const SizedBox(height: 16),

                  /* Şifre tekrar */
                  CustomTextField(
                    controller : _pwdConfirmCtrl,
                    hintText   : 'Şifre Tekrar',
                    obscureText: _obscure2,
                    prefixIcon : const AssetIcon(AppAssets.lockIcon),
                    suffixIcon : GestureDetector(
                      onTap : _toggle2,
                      child : AssetIcon(_obscure2 ? AppAssets.eyeClosed : AppAssets.eyeOpen),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty)      return 'Şifre tekrar boş olamaz';
                      if (v != _pwdCtrl.text)          return 'Şifreler eşleşmiyor';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildAgreement(),                      // <── fixed
                  const SizedBox(height: 24),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (_, s) => CustomButton(
                      text      : 'Şimdi Kaydol',
                      isLoading : s is AuthLoading,
                      onPressed : _submit,
                    ),
                  ),
                  const SizedBox(height: 24),

                  /* Social buttons */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialBtn(AppAssets.googleIcon,   onTap: () {}),
                      const SizedBox(width: 20),
                      _SocialBtn(AppAssets.appleIcon,    onTap: () {}),
                      const SizedBox(width: 20),
                      _SocialBtn(AppAssets.facebookIcon, onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 32),

                  _BottomPrompt(
                    question: 'Zaten bir hesabın var mı? ',
                    action  : 'Giriş Yap',
                    onTap   : () => context.go(AppRouter.loginPath),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* ------------ agreement row (FIXED) ------------ */
  Widget _buildAgreement() => Row(
    children: [
      Checkbox(
        value       : _agree,
        onChanged   : (v) => setState(() => _agree = v ?? false),
        activeColor : AppColors.primaryRed,
        checkColor  : AppColors.white,
        side        : const BorderSide(color: AppColors.lightGrey),
      ),
      Expanded(
        child: RichText(
          text: TextSpan(
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.lightGrey),
            children: [
              const TextSpan(text: 'Kullanıcı sözleşmesini '),
              TextSpan(
                  text: 'okudum ve kabul ediyorum.',
                  style: const TextStyle(
                    color: AppColors.primaryRed,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {/* open doc */}),
            ],
          ),
        ),
      ),
    ],
  );
}

/* ───────── auxiliary widgets ───────── */

class _SocialBtn extends StatelessWidget {
  const _SocialBtn(this.icon, {required this.onTap});
  final String icon;
  final VoidCallback onTap;

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
              color: AppColors.primaryRed, fontWeight: FontWeight.bold),
          recognizer: TapGestureRecognizer()..onTap = onTap,
        ),
      ],
    ),
  );
}
