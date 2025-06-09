import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/features/profissional/roadmap/consulta_detalhes/consulta_detalhes_controller.dart';

class ConsultaLoadingWidget extends StatelessWidget {
  const ConsultaLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 48),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/loading_animation.gif',
                      height: 120,
                      width: 120,
                      fit: BoxFit.contain,
                      frameBuilder: (
                        context,
                        child,
                        frame,
                        wasSynchronouslyLoaded,
                      ) {
                        if (frame == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return child;
                      },
                      cacheWidth: 240,
                      cacheHeight: 240,
                      filterQuality: FilterQuality.low,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    ConsultaDetalhesController.tituloProcessando,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    ConsultaDetalhesController.mensagemProcessando,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const LinearProgressIndicator(
                    backgroundColor: AppColors.primaryLight,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    minHeight: 6,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: AppColors.primaryLight,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ConsultaDetalhesController.dicaProcessamento,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
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
