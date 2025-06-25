import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';
import 'package:careflow_app/app/features/paciente/historico/historico_paciente_controller.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;

class HistoricoContentWidget extends StatelessWidget {
  final HistoricoPacienteController controller;

  const HistoricoContentWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              'Histórico do Paciente',
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
                  padding: const EdgeInsets.all(8.0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  styleSheet: controller.markdownStyle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
