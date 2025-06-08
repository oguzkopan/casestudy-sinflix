/// Centralised asset paths.
///
/// 1. **Nothing removed** – all previously-defined constants are intact.
/// 2. **New additions** – `proIcon`, `placeholder`, and an alias `back`.
class AppAssets {
  static const _logoBasePath    = 'assets/logo';
  static const _imagesBasePath  = 'assets/images';
  static const _lottieBasePath  = 'assets/lottie';
  static const subscription = 'assets/images/subscription.png';

  /* -------------------- LOGO -------------------- */
  static const appLogo    = '$_logoBasePath/app_icon.png';
  static const splashLogo = '$_logoBasePath/splash_logo.png';

  /* ---------------- SOCIAL LOGIN ---------------- */
  static const googleIcon   = '$_imagesBasePath/google.png';
  static const facebookIcon = '$_imagesBasePath/facebook.png';
  static const appleIcon    = '$_imagesBasePath/apple.png';

  /* ------------------ LOTTIE -------------------- */
  static const loadingLottie = '$_lottieBasePath/loading_animation.json';

  /* --------------- PHOTO-UPLOAD ----------------- */
  static const backIcon = '$_imagesBasePath/back.png';
  static const plusIcon = '$_imagesBasePath/plus.png';

  /// **Alias** so earlier snippets that used `AppAssets.back` keep compiling.
  /// Prefer `backIcon` in any new code.
  static const back = backIcon;

  /* --------------- BOTTOM BAR ------------------- */
  static const home    = '$_imagesBasePath/home.png';
  static const profile = '$_imagesBasePath/profile.png';

  /* ---------------- LIKE BTN -------------------- */
  static const like = '$_imagesBasePath/like.png';

  /* -------------- TEXT-FIELD ICONS -------------- */
  static const mailIcon  = '$_imagesBasePath/mail.png';
  static const lockIcon  = '$_imagesBasePath/unlock.png';
  static const nameIcon  = '$_imagesBasePath/name.png';
  static const eyeClosed = '$_imagesBasePath/hide.png';
  static const eyeOpen   = '$_imagesBasePath/hide.png';

  /* --------------- SUBSCRIPTION ----------------- */
  static const proIcon    = '$_imagesBasePath/pro.png';

  /* ------------- GENERIC PLACEHOLDER ------------ */
  static const placeholder = '$_imagesBasePath/placeholder.png';
}
