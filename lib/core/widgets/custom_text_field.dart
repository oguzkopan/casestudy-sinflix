import 'package:flutter/material.dart';
import 'package:sin_flix/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        hintText: hintText,

        prefixIconConstraints:
        const BoxConstraints(minWidth: 30, minHeight: 30),
        suffixIconConstraints:
        const BoxConstraints(minWidth: 30, minHeight: 30),

        contentPadding:
        const EdgeInsets.symmetric(vertical: 14),

        prefixIcon: prefixIcon == null
            ? null
            : Padding(
          padding: const EdgeInsets.only(left: 10, right: 4),
          child: prefixIcon,
        ),
        suffixIcon: suffixIcon == null
            ? null
            : Padding(
          padding: const EdgeInsets.only(right: 10, left: 4),
          child: suffixIcon,
        ),
      ),

    );
  }
}