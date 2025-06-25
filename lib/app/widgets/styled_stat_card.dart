import 'package:flutter/material.dart';
import '../core/ui/app_colors.dart';
import '../core/ui/app_text_styles.dart';

class StyledStatCard extends StatelessWidget {
  const StyledStatCard({
    super.key,
    required this.title,
    required this.value,
    this.backgroundColor = AppColors.primaryDark,
    this.accentColor = AppColors.primaryLight,
    this.titleColor = AppColors.primaryLight,
    this.valueColor = AppColors.primaryLight,
    this.icon,
    this.customIcon,
    this.onTap,
  });

  final String title;
  
  final String value;
  
  final Color backgroundColor;
  final Color accentColor;
  final Color titleColor;
  final Color valueColor;
  final IconData? icon;
  final Widget? customIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.3),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -15,
              right: -15,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.bodyMediumBold.copyWith(
                            color: titleColor,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          value,
                          style: AppTextStyles.displayLarge.copyWith(
                            color: valueColor,
                            letterSpacing: -0.5,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (customIcon != null)
                    customIcon!
                  else if (icon != null)
                    Icon(
                      icon,
                      color: titleColor.withValues(alpha: 0.3),
                      size: 40,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  factory StyledStatCard.patients({
    required String count,
    VoidCallback? onTap,
  }) {
    return StyledStatCard(
      title: 'Pacientes',
      value: count,
      backgroundColor: AppColors.primaryDark,
      accentColor: AppColors.primaryLight,
      titleColor: AppColors.primaryLight,
      valueColor: AppColors.primaryLight,
      icon: Icons.people_rounded,
      onTap: onTap,
    );
  }

  factory StyledStatCard.consultations({
    required String count,
    VoidCallback? onTap,
  }) {
    return StyledStatCard(
      title: 'Consultas',
      value: count,
      backgroundColor: AppColors.primaryDark,
      accentColor: AppColors.primaryLight,
      titleColor: AppColors.primaryLight,
      valueColor: AppColors.primaryLight,
      icon: Icons.calendar_today_rounded,
      onTap: onTap,
    );
  }

  factory StyledStatCard.notifications({
    required String count,
    VoidCallback? onTap,
  }) {
    return StyledStatCard(
      title: 'Notificações',
      value: count,
      backgroundColor: AppColors.primaryDark,
      accentColor: AppColors.successLight,
      titleColor: AppColors.successLight,
      valueColor: AppColors.successLight,
      icon: Icons.notifications_rounded,
      onTap: onTap,
    );
  }
}
