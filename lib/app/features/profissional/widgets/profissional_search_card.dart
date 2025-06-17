import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/ui_helpers.dart';



class ProfissionalSearchCard extends StatelessWidget {
  final String nome;
  final String especialidade;
  final String numeroRegistro;
  final String? profileUrlImage; // Added profileUrlImage

  const ProfissionalSearchCard({
    super.key,
    required this.nome,
    required this.especialidade,
    required this.numeroRegistro,
    this.profileUrlImage, // Added profileUrlImage to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Elevation, margin, shape, and color will be inherited from AppTheme.cardTheme
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Placeholder for the professional's image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Builder(
                builder: (context) {
                  if (profileUrlImage != null && profileUrlImage!.isNotEmpty) {
                    return CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(profileUrlImage!),
                      backgroundColor: Colors.transparent, // Or a subtle placeholder color
                    );
                  } else {
                    final String initials = UiHelpers.getInitials(nome);
                    final Color avatarColor = UiHelpers.getAvatarBackgroundColor(nome);
                    final Color initialsColor = UiHelpers.getInitialsTextColor(avatarColor);
                    return CircleAvatar(
                      radius: 30,
                      backgroundColor: avatarColor,
                      child: Text(
                        initials,
                        style: TextStyle(color: initialsColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            // Professional's details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome,
                    style: Theme.of(context).textTheme.titleMedium, // Uses AppTextStyles.titleMedium via AppTheme
                  ),
                  const SizedBox(height: 4),
                  Text(
                    especialidade,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryDark.withOpacity(0.9),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Registro: $numeroRegistro',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith( // Uses AppTextStyles.caption via AppTheme
                          color: AppColors.primary.withOpacity(0.8),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
