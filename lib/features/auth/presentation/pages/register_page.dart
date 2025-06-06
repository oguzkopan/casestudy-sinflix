import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sin_flix/app/app_router.dart';
import 'package:sin_flix/core/constants/app_assets.dart';
import 'package:sin_flix/core/theme/app_colors.dart';
import 'package:sin_flix/core/widgets/custom_button.dart';
import 'package:sin_flix/core/widgets/custom_text_field.dart';
import 'package:sin_flix/features/auth/presentation/bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();
  bool _obscureText = true;
  bool _agreedToTerms = false;
  DateTime? _selectedBirthDate;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryRed,
              onPrimary: AppColors.white,
              surface: AppColors.darkGrey,
              onSurface: AppColors.white,
            ),
            dialogBackgroundColor: AppColors.mediumGrey,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _register() {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Kullanıcı sözleşmesini kabul etmelisiniz.'),
        backgroundColor: AppColors.primaryRed,
      ));
      return;
    }
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthRegisterRequested(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        birthDate: DateFormat('yyyy-MM-dd').format(_selectedBirthDate!),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;

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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.02),
                  Text('Hoşgeldiniz', textAlign: TextAlign.center, style: textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    'Tempus varius ei vitae interdum id charter elementum tristique eleifend elit.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(color: AppColors.lightGrey),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'Ad Soyad',
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (value) => value == null || value.isEmpty ? 'Ad Soyad boş olamaz' : null,
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _birthDateController,
                    hintText: 'Doğum Tarihi',
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    readOnly: true,
                    onTap: () => _selectBirthDate(context),
                    validator: (value) => value == null || value.isEmpty ? 'Doğum tarihi boş olamaz' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTermsAgreement(context),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Şimdi Kaydol',
                        onPressed: _register,
                        isLoading: state is AuthLoading,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSocialRegisterButtons(context),
                  const SizedBox(height: 32),
                  _buildLoginPrompt(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsAgreement(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _agreedToTerms,
          onChanged: (bool? value) {
            setState(() {
              _agreedToTerms = value ?? false;
            });
          },
          activeColor: AppColors.primaryRed,
          checkColor: AppColors.white,
          side: const BorderSide(color: AppColors.lightGrey),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.lightGrey),
              children: [
                const TextSpan(text: 'Kullanıcı sözleşmesini '),
                TextSpan(
                  text: 'okudum ve kabul ediyorum.',
                  style: const TextStyle(color: AppColors.primaryRed, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: ' Tüm '),
                TextSpan(
                  text: 'şartları kabul ediyorum.',
                  style: const TextStyle(color: AppColors.primaryRed, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildSocialRegisterButtons(BuildContext context) {
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

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Zaten bir hesabın var mı? ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.lightGrey),
          children: <TextSpan>[
            TextSpan(
              text: 'Giriş Yap',
              style: const TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()..onTap = () => context.go(AppRouter.loginPath),
            ),
          ],
        ),
      ),
    );
  }
}