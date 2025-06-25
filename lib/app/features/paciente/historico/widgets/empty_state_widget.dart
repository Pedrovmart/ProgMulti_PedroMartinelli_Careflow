import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';

class HistoricoEmptyStateWidget extends StatelessWidget {
  const HistoricoEmptyStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.history,
              color: AppColors.primaryLight,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum histórico disponível',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Não há histórico disponível para este paciente.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
