import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';

Future<void> showAtualizarDiagnosticoDialog({
  required BuildContext context,
  required String diagnosticoInicial,
  required Future<void> Function(String) onConfirmar,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController(text: diagnosticoInicial);
      bool isLoading = false;
      
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              'Atualizar Diagnóstico',
              style: AppTextStyles.titleLarge,
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller: controller,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: 'Digite o novo diagnóstico aqui...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                  style: AppTextStyles.bodyMedium,
                  validator: (value) =>
                      value?.trim().isEmpty ?? true ? 'Por favor, insira o diagnóstico' : null,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (formKey.currentState?.validate() ?? false) {
                          setState(() => isLoading = true);
                          
                          try {
                            await onConfirmar(controller.text.trim());
                            
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Diagnóstico atualizado com sucesso!'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              setState(() => isLoading = false);
                              
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
                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                ),
                child: isLoading
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
    },
  );
}
