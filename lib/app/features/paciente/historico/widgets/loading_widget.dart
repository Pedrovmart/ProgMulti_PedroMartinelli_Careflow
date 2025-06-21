import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';

class HistoricoLoadingWidget extends StatelessWidget {
  const HistoricoLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          SizedBox(height: 16),
          Text('Carregando histórico do paciente...'),
        ],
      ),
    );
  }
}
