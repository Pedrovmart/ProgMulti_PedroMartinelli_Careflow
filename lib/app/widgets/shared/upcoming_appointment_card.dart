import 'package:flutter/material.dart';
import '../../core/ui/app_colors.dart';
import '../../core/ui/ui_helpers.dart';
import '../../core/ui/app_text_styles.dart';

class AppointmentCardData {
  final String imageUrl;
  final String title;
  final String? subtitle1;
  final String subtitle2;
  final VoidCallback? onTap;

  AppointmentCardData({
    required this.imageUrl,
    required this.title,
    this.subtitle1,
    required this.subtitle2,
    this.onTap,
  });
}

class UpcomingAppointmentCard extends StatelessWidget {
  final AppointmentCardData data;

  const UpcomingAppointmentCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            (data.imageUrl.isNotEmpty)
                ? CircleAvatar(
                    radius: 28.0,
                    backgroundImage: NetworkImage(data.imageUrl),
                    backgroundColor: AppColors.light.withValues(alpha: 0.5), 
                  )
                : CircleAvatar(
                    radius: 28.0,
                    backgroundColor: UiHelpers.getAvatarBackgroundColor(data.title), 
                    child: Text(
                      UiHelpers.getInitials(data.title),
                      style: TextStyle(
                        color: UiHelpers.getInitialsTextColor(UiHelpers.getAvatarBackgroundColor(data.title)),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0, 
                      ),
                    ),
                  ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (data.subtitle1 != null && data.subtitle1!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        data.subtitle1!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: data.subtitle1 != null && data.subtitle1!.isNotEmpty ? 2.0 : 4.0),
                    child: Text(
                      data.subtitle2,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.accentDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (data.onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.accent,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
