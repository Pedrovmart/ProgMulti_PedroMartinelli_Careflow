import 'package:flutter/material.dart';
import 'package:careflow_app/app/features/profissional/controllers/consulta_detalhes_controller.dart';
import 'package:careflow_app/app/features/profissional/consulta_detalhes_page.dart';

class EmptyStateWidget extends StatelessWidget {
  final String idProfissional;
  final String idPaciente;
  final String nomePaciente;
  final ConsultaDetalhesController controller;

  const EmptyStateWidget({
    super.key,
    required this.idProfissional,
    required this.idPaciente,
    required this.nomePaciente,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.info_outline,
            size: 60,
            color: Colors.grey,
          ),
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
          ElevatedButton.icon(
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
            icon: const Icon(Icons.refresh, size: 20),
            label: Text(ConsultaDetalhesController.textoBotaoTentarNovamente),
            style: controller.primaryButtonStyle,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              ConsultaDetalhesController.textoBotaoVoltar,
              style: controller.textButtonStyle,
            ),
          ),
        ],
      ),
    );
  }
}
