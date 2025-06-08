import 'package:flutter/material.dart';
import 'package:sin_flix/core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading     = false,
    this.backgroundColor = AppColors.primaryRed,
    this.textColor       = AppColors.white,
    this.borderRadius    = 8,
    this.padding         = const EdgeInsets.symmetric(vertical: 16),
    this.icon,
    this.textStyle,
    this.fullWidth       = true,
  });

  /* ------------------------------------------------------------------ */
  /// Small pill-shaped helper used on profile page (“Fotoğraf Ekle”)
  factory CustomButton.mini({
    required String text,
    required VoidCallback onPressed,
  }) {
    return CustomButton(
      text       : text,
      onPressed  : onPressed,
      padding    : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      borderRadius: 20,
      textStyle  : const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      fullWidth  : false,
    );
  }

  /* ------------------------------------------------------------------ */
  final String            text;
  final VoidCallback?     onPressed;
  final bool              isLoading;
  final Color             backgroundColor;
  final Color             textColor;
  final double            borderRadius;
  final EdgeInsets        padding;
  final Widget?           icon;
  final TextStyle?        textStyle;
  final bool              fullWidth;   // false for the mini-variant

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        minimumSize: fullWidth ? const Size(double.infinity, 50) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
        ),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: textStyle ??
                const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
