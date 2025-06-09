import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/features/profissional/roadmap/consulta_detalhes/consulta_detalhes_controller.dart';

class ConsultaEmptyStateWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const ConsultaEmptyStateWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              ConsultaDetalhesController.mensagemSemConteudo,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (onRetry != null)
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
                style: TextStyle(color: AppColors.primary, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
