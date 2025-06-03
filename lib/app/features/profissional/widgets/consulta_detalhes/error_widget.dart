import 'package:flutter/material.dart';
import 'package:careflow_app/app/features/profissional/controllers/consulta_detalhes_controller.dart';
import 'package:careflow_app/app/features/profissional/consulta_detalhes_page.dart';

class ConsultaErrorWidget extends StatelessWidget {
  final ConsultaDetalhesController controller;
  final String idProfissional;
  final String idPaciente;
  final String nomePaciente;

  const ConsultaErrorWidget({
    super.key,
    required this.controller,
    required this.idProfissional,
    required this.idPaciente,
    required this.nomePaciente,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone de erro
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
            // Mensagem de erro
            Text(
              'Ocorreu um erro',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Detalhes do erro
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                controller.errorMessage!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            // Botão para tentar novamente
            ElevatedButton(
              onPressed: () {
                // Recarregar a página
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConsultaDetalhesPage(
                      idProfissional: idProfissional,
                      idPaciente: idPaciente,
                      nomePaciente: nomePaciente,
                    ),
                  ),
                );
              },
              style: controller.primaryButtonStyle,
              child: Text(
                ConsultaDetalhesController.textoBotaoTentarNovamente,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Link para voltar
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                ConsultaDetalhesController.textoBotaoVoltar,
                style: controller.textButtonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método estático para criar a rota
  static Route<void> route({
    required String idProfissional,
    required String idPaciente,
    required String nomePaciente,
  }) {
    return MaterialPageRoute(
      builder: (context) => ConsultaDetalhesPage(
        idProfissional: idProfissional,
        idPaciente: idPaciente,
        nomePaciente: nomePaciente,
      ),
    );
  }
}
