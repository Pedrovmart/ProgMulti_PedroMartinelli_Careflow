import 'package:careflow_app/app/features/consultas/widgets/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/features/consultas/pacientes_agendamentos_controller.dart';
import 'package:careflow_app/app/features/consultas/widgets/events_list_widget.dart';
import 'package:careflow_app/app/features/consultas/widgets/form_widget.dart';

class PacientesAgendamentosPage extends StatelessWidget {
  const PacientesAgendamentosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PacientesAgendamentosController>(
          create: (context) {
            final consultasProvider = Provider.of<ConsultasProvider>(
              context,
              listen: false,
            );
            final profissionalProvider = Provider.of<ProfissionalProvider>(
              context,
              listen: false,
            );
            final authProvider = Provider.of<AuthProvider>(context, listen: false);

            return PacientesAgendamentosController(
              consultasProvider,
              profissionalProvider,
              authProvider,
            )..init();
          },
        ),
        // Garante que o ProfissionalProvider está disponível para os filhos
        ProxyProvider<PacientesAgendamentosController, ProfissionalProvider>(
          update: (_, controller, __) => controller.profissionalProvider,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agendar Consulta'),
          // O estilo do AppBar (backgroundColor, foregroundColor, titleTextStyle, etc.)
          // será herdado do appBarTheme definido em AppTheme.dart
        ),
        body: const _PacientesAgendamentosPageContent(),
      ),
    );
  }
}

class _PacientesAgendamentosPageContent extends StatefulWidget {
  const _PacientesAgendamentosPageContent();

  @override
  _PacientesAgendamentosPageContentState createState() => _PacientesAgendamentosPageContentState();
}

class _PacientesAgendamentosPageContentState extends State<_PacientesAgendamentosPageContent> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PacientesAgendamentosController>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CalendarWidget(controller: controller),
            const SizedBox(height: 20),
            EventsListWidget(controller: controller),
            const SizedBox(height: 20),
            FormWidget(controller: controller),
          ],
        ),
      ),
    );
  }
}
