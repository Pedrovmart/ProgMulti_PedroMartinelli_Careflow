import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:careflow_app/app/features/profissional/roadmap/consulta_detalhes/consulta_detalhes_controller.dart';
import 'package:careflow_app/app/features/profissional/roadmap/consulta_detalhes/widgets/consulta_content_widget.dart';
import 'package:careflow_app/app/features/profissional/roadmap/consulta_detalhes/widgets/empty_state_widget.dart';
import 'package:careflow_app/app/features/profissional/roadmap/consulta_detalhes/widgets/error_widget.dart';
import 'package:careflow_app/app/features/profissional/roadmap/consulta_detalhes/widgets/loading_widget.dart';

class ConsultaDetalhesPage extends StatelessWidget {
  final String idProfissional;
  final String idPaciente;
  final String nomePaciente;
  final String? idConsulta;

  const ConsultaDetalhesPage({
    super.key,
    required this.idProfissional,
    required this.idPaciente,
    required this.nomePaciente,
    this.idConsulta,
  });

  static const String route = '/profissional/consulta-detalhes';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (context) => ConsultaDetalhesController(
            Provider.of<ConsultasProvider>(context, listen: false),
          )..carregarDetalhesConsulta(
            idProfissional: idProfissional,
            idPaciente: idPaciente,
            idConsulta: idConsulta,
          ),
      child: _ConsultaDetalhesView(
        idProfissional: idProfissional,
        idPaciente: idPaciente,
        nomePaciente: nomePaciente,
      ),
    );
  }
}

class _ConsultaDetalhesView extends StatelessWidget {
  final String idProfissional;
  final String idPaciente;
  final String nomePaciente;

  const _ConsultaDetalhesView({
    required this.idProfissional,
    required this.idPaciente,
    required this.nomePaciente,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ConsultaDetalhesController>();

    return Scaffold(body: _buildBody(controller, context));
  }

  Widget _buildBody(
    ConsultaDetalhesController controller,
    BuildContext context,
  ) {
    if (controller.isLoading && controller.detalhesConsulta == null) {
      return const ConsultaLoadingWidget();
    }

    if (controller.errorMessage != null) {
      return ConsultaErrorWidget(
        errorMessage: controller.errorMessage!,
        onRetry:
            () => controller.carregarDetalhesConsulta(
              idProfissional: idProfissional,
              idPaciente: idPaciente,
            ),
      );
    }

    if (controller.detalhesConsulta == null) {
      return const ConsultaEmptyStateWidget();
    }

    return ConsultaContentWidget(
      controller: controller,
      idProfissional: idProfissional,
      idPaciente: idPaciente,
      idConsulta: controller.idConsulta ?? '',
    );
  }
}
