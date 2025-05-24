import 'package:flutter/material.dart';

import '../../core/ui/app_colors.dart';
import '../../core/ui/app_text_styles.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  
  final String? userImageUrl;
  
  final String? userName;
  
  final String? userRole;
  
  final bool showNotificationIcon;
  
  final VoidCallback? onNotificationPressed;
  
  final VoidCallback? onProfilePressed;
  
  final bool showLogoutButton;
  
  final VoidCallback? onLogoutPressed;

  const DefaultAppBar({
    super.key,
    required this.title,
    this.userImageUrl,
    this.userName,
    this.userRole,
    this.showNotificationIcon = true,
    this.showLogoutButton = false,
    this.onNotificationPressed,
    this.onProfilePressed,
    this.onLogoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onProfilePressed,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: userImageUrl != null
                        ? NetworkImage(userImageUrl!)
                        : null,
                    child: userImageUrl == null
                        ? const Icon(Icons.person, size: 24)
                        : null,
                  ),
                  const SizedBox(width: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá,',
                        style: AppTextStyles.bodyMedium,
                      ),
                      Text(
                        userName ?? 'Usuário',
                        style: AppTextStyles.headlineLarge,
                      ),
                      if (userRole != null)
                        Text(
                          userRole!,
                          style: AppTextStyles.caption,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (showLogoutButton)
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Theme.of(context).appBarTheme.iconTheme?.color ??
                      AppColors.primaryDark,
                ),
                onPressed: onLogoutPressed,
                tooltip: 'Sair',
                splashRadius: 24.0,
                padding: const EdgeInsets.all(8.0),
              )
            else if (showNotificationIcon)
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).appBarTheme.iconTheme?.color ??
                      AppColors.primaryDark,
                ),
                onPressed: onNotificationPressed,
                splashRadius: 24.0,
                padding: const EdgeInsets.all(8.0),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10.0);
}
