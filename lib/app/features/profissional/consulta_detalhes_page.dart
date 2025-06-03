import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:careflow_app/app/features/profissional/controllers/consulta_detalhes_controller.dart';
import 'package:careflow_app/app/features/profissional/widgets/consulta_detalhes/consulta_detalhes_widgets.dart';

class ConsultaDetalhesPage extends StatelessWidget {
  final String idProfissional;
  final String idPaciente;
  final String nomePaciente;

  const ConsultaDetalhesPage({
    super.key,
    required this.idProfissional,
    required this.idPaciente,
    required this.nomePaciente,
  });

  static const String route = '/profissional/consulta-detalhes';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConsultaDetalhesController(
        Provider.of<ConsultasProvider>(context, listen: false),
      )..carregarDetalhesConsulta(
          idProfissional: idProfissional,
          idPaciente: idPaciente,
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
    final theme = Theme.of(context);

    return Scaffold(
      body: _buildBody(context, controller, theme),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ConsultaDetalhesController controller,
    ThemeData theme,
  ) {
    if (controller.isLoading) {
      return LoadingWidget(controller: controller);
    }

    if (controller.errorMessage != null) {
      return ConsultaErrorWidget(
        controller: controller,
        idProfissional: idProfissional,
        idPaciente: idPaciente,
        nomePaciente: nomePaciente,
      );
    }

    if (controller.markdownContent == null) {
      return EmptyStateWidget(
        idProfissional: idProfissional,
        idPaciente: idPaciente,
        nomePaciente: nomePaciente,
        controller: controller,
      );
    }

    return ConsultaContentWidget(controller: controller);
  }
}
