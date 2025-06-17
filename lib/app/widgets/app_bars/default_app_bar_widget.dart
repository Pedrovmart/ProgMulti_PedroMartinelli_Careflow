import 'package:careflow_app/app/core/providers/paciente_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/ui/app_colors.dart';
import '../../core/ui/app_text_styles.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // Title is not directly used in the current design, but kept for potential future use
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    String? currentImageUrl = userImageUrl;
    if (authProvider.userType == 'paciente') {
      currentImageUrl = Provider.of<PacienteProvider>(context, listen: false).currentProfileImage ?? userImageUrl;
    } else if (authProvider.userType == 'profissional') {
      currentImageUrl = Provider.of<ProfissionalProvider>(context, listen: false).currentProfileImage ?? userImageUrl;
    }

    return Container(
      padding: const EdgeInsets.only(top: kToolbarHeight / 2.5), 
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0), 
          child: Row(
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
                        width: 44, 
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.accent.withOpacity(0.7), width: 1.5),
                        ),
                        child: CircleAvatar(
                          backgroundColor: AppColors.light.withOpacity(0.1),
                          backgroundImage: (currentImageUrl != null && currentImageUrl.isNotEmpty)
                              ? NetworkImage(currentImageUrl)
                              : null,
                          child: (currentImageUrl == null || currentImageUrl.isEmpty)
                              ? const Icon(
                                  Icons.person_outline_rounded,
                                  size: 24,
                                  color: AppColors.light,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName ?? 'Usuário',
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.light,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (userRole != null && userRole!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2, // Reduzido para corrigir pequeno overflow
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  userRole!,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w600,
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
                _buildActionIconButton(
                  icon: Icons.logout_rounded,
                  onPressed: onLogoutPressed,
                  tooltip: 'Sair',
                  iconColor: AppColors.light,
                )
              else if (showNotificationIcon)
                _buildActionIconButton(
                  icon: Icons.notifications_none_rounded,
                  onPressed: onNotificationPressed,
                  tooltip: 'Notificações',
                  iconColor: AppColors.light,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildActionIconButton({
  required IconData icon,
  required VoidCallback? onPressed,
  required String tooltip,
  required Color iconColor,
}) {
  return IconButton(
    icon: Icon(icon, size: 24), 
    color: iconColor,
    onPressed: onPressed,
    tooltip: tooltip,
    splashRadius: 24, 
  );
}
