import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';
import 'package:careflow_app/app/features/profissional/roadmap/consulta_detalhes/consulta_detalhes_controller.dart';
import 'package:careflow_app/app/features/profissional/roadmap/consulta_detalhes/widgets/atualizar_diagnostico_dialog.dart';
import 'package:provider/provider.dart';

class ConsultaContentWidget extends StatelessWidget {
  final ConsultaDetalhesController controller;
  final String idProfissional;
  final String idPaciente;
  final String idConsulta;

  const ConsultaContentWidget({
    super.key,
    required this.controller,
    required this.idProfissional,
    required this.idPaciente,
    required this.idConsulta,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ConsultaDetalhesController>(
      builder: (context, controller, _) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Detalhes da Consulta',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.primaryLight,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      color: AppColors.primaryLight.withValues(alpha: 0.5),
                      width: 1.0,
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: md.Markdown(
                      data: controller.markdownContent!,
                      styleSheet: controller.markdownStyle.copyWith(
                        p: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.black87,
                          height: 1.5,
                        ),
                        h1: AppTextStyles.headlineLarge.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                        h2: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: ElevatedButton(
                  onPressed:
                      () => _showUpdateDiagnosticoDialog(
                        context,
                        controller,
                        idProfissional: idProfissional,
                        idPaciente: idPaciente,
                        idConsulta: idConsulta,
                      ),
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
                  child: const Text('Atualizar Diagnóstico'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showUpdateDiagnosticoDialog(
    BuildContext context,
    ConsultaDetalhesController controller, {
    required String idProfissional,
    required String idPaciente,
    required String idConsulta,
  }) async {
    if (controller.detalhesConsulta == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível carregar os detalhes da consulta'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    try {
      final diagnosticoAtual = controller.detalhesConsulta?['diagnostico'] ?? '';
      
      await showAtualizarDiagnosticoDialog(
        context: context,
        diagnosticoInicial: diagnosticoAtual,
        onConfirmar: (novoDiagnostico) async {

          await controller.atualizarDiagnostico(
            context: context,
            idProfissional: idProfissional,
            idPaciente: idPaciente,
            novoDiagnostico: novoDiagnostico,
          );

          controller.atualizarConteudoSemFormatacao();
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao abrir o diálogo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
