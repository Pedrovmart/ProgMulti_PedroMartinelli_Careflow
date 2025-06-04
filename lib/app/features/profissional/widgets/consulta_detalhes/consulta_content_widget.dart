import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';
import 'package:careflow_app/app/features/profissional/controllers/consulta_detalhes_controller.dart';
import 'package:provider/provider.dart';

class ConsultaContentWidget extends StatelessWidget {
  final ConsultaDetalhesController controller;

  const ConsultaContentWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ConsultaDetalhesController>(
      builder: (context, controller, _) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Text(
                'Detalhes da Consulta',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Conteúdo da consulta
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: md.Markdown(
                      data: controller.markdownContent!,
                      styleSheet: controller.markdownStyle,
                      padding: const EdgeInsets.all(8.0),
                      shrinkWrap: true,
                    ),
                  ),
                ),
              ),
              // Botão de Atualizar Diagnóstico
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showUpdateDiagnosticoDialog(context, controller),
                  icon: const Icon(Icons.edit_note, size: 20),
                  label: const Text('Atualizar Diagnóstico'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8)
            ],
          ),
        );
      },
    );
  }

  Future<void> _showUpdateDiagnosticoDialog(
    BuildContext context,
    ConsultaDetalhesController controller,
  ) async {
    final _formKey = GlobalKey<FormState>();
    final _diagnosticoController = TextEditingController(
      text: controller.markdownContent,
    );

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atualizar Diagnóstico'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _diagnosticoController,
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: 'Digite o novo diagnóstico aqui...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o diagnóstico';
                  }
                  return null;
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  try {
                    final idProfissional = ModalRoute.of(context)!.settings.arguments
                        as Map<String, dynamic>?;
                    
                    if (idProfissional != null) {
                      await controller.atualizarDiagnostico(
                        idProfissional: idProfissional['idProfissional'] as String,
                        idPaciente: idProfissional['idPaciente'] as String,
                        novoDiagnostico: _diagnosticoController.text,
                      );
                      
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Diagnóstico atualizado com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao atualizar diagnóstico: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: controller.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
