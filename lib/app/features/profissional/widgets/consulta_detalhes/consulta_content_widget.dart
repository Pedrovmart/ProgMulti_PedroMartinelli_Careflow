import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';
import 'package:careflow_app/app/features/profissional/controllers/consulta_detalhes_controller.dart';

class ConsultaContentWidget extends StatelessWidget {
  final ConsultaDetalhesController controller;

  const ConsultaContentWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Detalhes da Consulta',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
        ],
      ),
    );
  }
}
