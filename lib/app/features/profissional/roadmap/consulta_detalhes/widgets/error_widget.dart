import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';

class ConsultaErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ConsultaErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Ocorreu um erro',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Tentar Novamente'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Voltar',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
