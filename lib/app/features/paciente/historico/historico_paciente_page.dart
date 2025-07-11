import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:careflow_app/app/core/providers/paciente_provider.dart';
import 'package:careflow_app/app/features/paciente/historico/historico_paciente_controller.dart';
import 'package:careflow_app/app/features/paciente/historico/widgets/content_widget.dart';
import 'package:careflow_app/app/features/paciente/historico/widgets/empty_state_widget.dart';
import 'package:careflow_app/app/features/paciente/historico/widgets/error_widget.dart';
import 'package:careflow_app/app/features/paciente/historico/widgets/loading_widget.dart';
import 'package:careflow_app/app/widgets/back_nav/back_nav_widget.dart';
import 'package:careflow_app/app/features/paciente/paciente_home_page.dart';

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
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 56.0),
              child: _buildBody(controller, context),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackNavWidget(
                  label: 'Voltar',
                  onPressed: () => context.pushReplacement(PacienteHomePage.route),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    HistoricoPacienteController controller,
    BuildContext context,
  ) {
    switch (controller.uiState) {
      case HistoricoPacienteUiState.loading:
        return const HistoricoLoadingWidget();
      
      case HistoricoPacienteUiState.error:
        return HistoricoErrorWidget(
          errorMessage: controller.errorMessage!,
          onRetry: () => controller.carregarHistoricoPaciente(
            pacienteId: pacienteId,
          ),
        );
      
      case HistoricoPacienteUiState.empty:
        return const HistoricoEmptyStateWidget();
      
      case HistoricoPacienteUiState.content:
        return HistoricoContentWidget(
          controller: controller,
        );
    }
  }
}








