import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';

//TODO: Quando usuário tiver imagem remover placeholder

class ProfissionalSearchCard extends StatelessWidget {
  final String nome;
  final String especialidade;
  final String numeroRegistro;

  const ProfissionalSearchCard({
    super.key,
    required this.nome,
    required this.especialidade,
    required this.numeroRegistro,
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
              child: CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.accentLight.withOpacity(0.2),
                child: const Icon(Icons.person, size: 40, color: AppColors.accent),
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
