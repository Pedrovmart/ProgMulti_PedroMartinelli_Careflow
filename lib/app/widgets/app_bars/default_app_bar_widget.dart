import 'package:flutter/material.dart';

import '../../core/ui/app_colors.dart';
import '../../core/ui/app_text_styles.dart';

/// Uma AppBar personalizada e reutilizável que exibe informações do usuário e notificações.
/// 
/// Este widget é projetado para ser usado em toda a aplicação para manter a consistência
/// visual e reduzir a duplicação de código.
/// 
/// ## Recursos
/// - Exibe a foto de perfil do usuário (ou um ícone padrão se não houver imagem)
/// - Mostra o nome do usuário e sua função (opcional)
/// - Inclui um botão de notificações (opcional)
/// - Suporta ações personalizadas para toques no perfil e notificações
/// - Segue o tema visual do aplicativo
/// 
/// ## Exemplo de uso
/// ```dart
/// import '../../widgets/app_bars/default_app_bar_widget.dart';
/// 
/// // Em um StatefulWidget ou StatelessWidget:
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     appBar: DefaultAppBar(
///       title: 'Título da Página',
///       userName: 'Nome do Usuário',
///       userRole: 'Função do Usuário',
///       userImageUrl: 'url_da_imagem',
///       onNotificationPressed: () {
///         // Navegar para notificações
///       },
///       onProfilePressed: () {
///         // Navegar para perfil
///       },
///     ),
///     body: // ... resto do seu widget
///   );
/// }
/// ```

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Título exibido na barra de notificações do sistema (não visível na UI)
  final String title;
  
  /// URL da imagem de perfil do usuário. Se for nulo, será exibido um ícone de pessoa.
  final String? userImageUrl;
  
  /// Nome do usuário a ser exibido
  final String? userName;
  
  /// Função/cargo do usuário (opcional)
  final String? userRole;
  
  /// Define se o ícone de notificações deve ser exibido
  final bool showNotificationIcon;
  
  /// Callback chamado quando o botão de notificações é pressionado
  final VoidCallback? onNotificationPressed;
  
  /// Callback chamado quando a área do perfil é pressionada
  final VoidCallback? onProfilePressed;

  const DefaultAppBar({
    super.key,
    required this.title,
    this.userImageUrl,
    this.userName,
    this.userRole,
    this.showNotificationIcon = true,
    this.onNotificationPressed,
    this.onProfilePressed,
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
            if (showNotificationIcon)
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).appBarTheme.iconTheme?.color ??
                      AppColors.primaryDark,
                ),
                onPressed: onNotificationPressed ?? () {},
                splashRadius: 24.0,
                padding: const EdgeInsets.all(8.0),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8.0);
}
