import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';


class AtualizarDiagnosticoDialog extends StatelessWidget {
  final String diagnosticoInicial;
  final Function(String) onConfirmar;
  final bool isLoading;

  const AtualizarDiagnosticoDialog({
    super.key,
    required this.diagnosticoInicial,
    required this.onConfirmar,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: diagnosticoInicial);

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
              : () {
                  if (formKey.currentState?.validate() ?? false) {
                    onConfirmar(controller.text.trim());
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
  }
}

Future<void> showAtualizarDiagnosticoDialog({
  required BuildContext context,
  required String diagnosticoInicial,
  required Future<void> Function(String) onConfirmar,
  bool isLoading = false,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => AtualizarDiagnosticoDialog(
      diagnosticoInicial: diagnosticoInicial,
      isLoading: isLoading,
      onConfirmar: onConfirmar,
    ),
  );
}
