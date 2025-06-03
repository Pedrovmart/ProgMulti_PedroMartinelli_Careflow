import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/features/profissional/controllers/consulta_detalhes_controller.dart';

class LoadingWidget extends StatelessWidget {
  final ConsultaDetalhesController controller;

  const LoadingWidget({
    super.key,
    required this.controller,
  });

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
            // Container com sombra para o card
            Container(
              decoration: controller.loadingContainerDecoration,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gif de carregamento
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/loading_animation.gif',
                      //height: 120,
                      //width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Título
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
                  // Mensagem personalizada
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      ConsultaDetalhesController.mensagemProcessando,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Indicador de progresso com texto
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Carregando...',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            // Nota informativa
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                ConsultaDetalhesController.dicaProcessamento,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
