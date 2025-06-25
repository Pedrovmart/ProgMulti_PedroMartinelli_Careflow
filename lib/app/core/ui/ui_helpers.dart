import 'package:flutter/material.dart';
import 'app_colors.dart';

class UiHelpers {
  static final List<Color> _avatarColors = [
    AppColors.primary,
    AppColors.accent,
    AppColors.success,
    AppColors.primaryDark,
    AppColors.accentDark,
    AppColors.successDark,
    AppColors.primaryLight,
    AppColors.accentLight,
    AppColors.successLight,
 
  ];

  static Color getAvatarBackgroundColor(String nameOrId) {
    if (nameOrId.isEmpty) {
      return AppColors.light; 
    }
    final int hashCode = nameOrId.hashCode;
    final int index = hashCode.abs() % _avatarColors.length;
    return _avatarColors[index];
  }

  static Color getInitialsTextColor(Color backgroundColor) {
    final double luminance = (0.299 * backgroundColor.r +
            0.587 * backgroundColor.g +
            0.114 * backgroundColor.b) /
        255;

    return luminance > 0.5 ? AppColors.primaryDark : Colors.white;
  }

  static String getInitials(String name) {
    if (name.isEmpty) return '';
    List<String> nameParts = name.trim().split(RegExp(r'\s+'));
    if (nameParts.isEmpty) return '';

    String initials = nameParts[0][0];
    if (nameParts.length > 1 && nameParts.last.isNotEmpty) {
      initials += nameParts.last[0];
    } else if (nameParts[0].length > 1) {
      initials += nameParts[0][1];
    }
    return initials.toUpperCase();
  }
}
