import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careflow_app/app/core/providers/paciente_provider.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';
import 'package:careflow_app/app/features/paciente/historico/historico_paciente_controller.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;

class HistoricoPacientePage extends StatelessWidget {
  final String pacienteId;
  final String nomePaciente;

  const HistoricoPacientePage({
    super.key,
    required this.pacienteId,
    required this.nomePaciente,
  });

  static const String route = '/paciente/historico';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HistoricoPacienteController(
        Provider.of<PacienteProvider>(context, listen: false),
      )..carregarHistoricoPaciente(
        pacienteId: pacienteId,
      ),
      child: _HistoricoPacienteView(
        pacienteId: pacienteId,
        nomePaciente: nomePaciente,
      ),
    );
  }
}

class _HistoricoPacienteView extends StatelessWidget {
  final String pacienteId;
  final String nomePaciente;

  const _HistoricoPacienteView({
    required this.pacienteId,
    required this.nomePaciente,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HistoricoPacienteController>();

    return Scaffold(
      body: _buildBody(controller, context),
    );
  }

  Widget _buildBody(
    HistoricoPacienteController controller,
    BuildContext context,
  ) {
    if (controller.isLoading && controller.historicoData == null) {
      return const _HistoricoLoadingWidget();
    }

    if (controller.errorMessage != null) {
      return _HistoricoErrorWidget(
        errorMessage: controller.errorMessage!,
        onRetry: () => controller.carregarHistoricoPaciente(
          pacienteId: pacienteId,
        ),
      );
    }

    if (controller.historicoData == null || controller.historicoData!.isEmpty) {
      return const _HistoricoEmptyStateWidget();
    }

    return _HistoricoContentWidget(
      controller: controller,
    );
  }
}

class _HistoricoContentWidget extends StatelessWidget {
  final HistoricoPacienteController controller;

  const _HistoricoContentWidget({
    required this.controller,
  });

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

class _HistoricoLoadingWidget extends StatelessWidget {
  const _HistoricoLoadingWidget();

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

class _HistoricoErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _HistoricoErrorWidget({
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Ocorreu um erro:',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoricoEmptyStateWidget extends StatelessWidget {
  const _HistoricoEmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.history,
              color: AppColors.primaryLight,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum histórico disponível',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Não há histórico disponível para este paciente.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
