import 'package:flutter/material.dart';
import 'app_colors.dart';

const String _fontFamilyPrimary = 'Manrope';
const String _fontFamilySecondary = 'Noto Sans';

class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamilyPrimary,
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
    letterSpacing: -0.5,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _fontFamilyPrimary,
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryDark,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamilyPrimary,
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryDark,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamilyPrimary,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _fontFamilyPrimary,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryDark,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamilyPrimary,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryDark,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryDark,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.primary,
  );
  
  static const TextStyle bodyMediumBold = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.primary, 
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamilyPrimary,
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryLight,
  );

  static ButtonStyle get seeMoreTextButtonStyle {
    return TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.bold,
      ),
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
