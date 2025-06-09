import 'package:careflow_app/app/core/providers/paciente_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.5);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);

    String? currentImageUrl;

    if (authProvider.userType == 'paciente') {
      currentImageUrl =
          Provider.of<PacienteProvider>(context).currentProfileImage ??
          userImageUrl;
    } else if (authProvider.userType == 'profissional') {
      currentImageUrl =
          Provider.of<ProfissionalProvider>(context).currentProfileImage ??
          userImageUrl;
    }

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: theme.primaryColorDark,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 16.0,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onProfilePressed,
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryLight,
                                    AppColors.primaryDark,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: theme.cardColor,
                                child:
                                    currentImageUrl != null
                                        ? ClipOval(
                                          child: Image.network(
                                            currentImageUrl,
                                            width: 36,
                                            height: 36,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (
                                              context,
                                              child,
                                              loadingProgress,
                                            ) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value:
                                                      loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                  strokeWidth: 2,
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(
                                                      Icons.person,
                                                      size: 24,
                                                      color:
                                                          theme
                                                              .textTheme
                                                              .bodyLarge
                                                              ?.color,
                                                    ),
                                          ),
                                        )
                                        : Icon(
                                          Icons.person,
                                          size: 24,
                                          color:
                                              theme.textTheme.bodyLarge?.color,
                                        ),
                              ),
                            ),

                            const SizedBox(width: 12.0),

                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Olá,',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: theme.primaryColorLight,
                                      fontSize: 12,
                                      height: 1.1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    userName ?? 'Usuário',
                                    style: AppTextStyles.headlineLarge.copyWith(
                                      fontSize: 16,
                                      height: 1.2,
                                      fontWeight: FontWeight.w700,
                                      color: theme.primaryColorLight,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (userRole != null) ...[
                                    const SizedBox(height: 2),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: constraints.maxWidth * 0.6,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryLight
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        userRole!,
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.primaryLight,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          height: 1.2,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (showLogoutButton)
                      _buildIconButton(
                        context: context,
                        icon: Icons.logout_rounded,
                        onPressed: onLogoutPressed,
                        tooltip: 'Sair',
                      )
                    else if (showNotificationIcon)
                      _buildIconButton(
                        context: context,
                        icon: Icons.notifications_none_rounded,
                        onPressed: onNotificationPressed,
                        tooltip: 'Notificações',
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildIconButton({
  required BuildContext context,
  required IconData icon,
  required VoidCallback? onPressed,
  required String tooltip,
}) {
  return SizedBox(
    width: 40,
    height: 40,
    child: IconButton(
      icon: Icon(icon, size: 20),
      color: Theme.of(context).primaryColorLight,
      onPressed: onPressed,
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      splashRadius: 20,
    ),
  );
}
