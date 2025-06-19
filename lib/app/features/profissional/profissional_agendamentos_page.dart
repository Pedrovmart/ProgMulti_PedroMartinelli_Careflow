import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careflow_app/app/features/consultas/widgets/calendar_widget.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/features/consultas/widgets/events_list_widget.dart';
import 'package:careflow_app/app/features/profissional/profissional_agendamentos_controller.dart';

class ProfissionalAgendamentosPage extends StatelessWidget {
  const ProfissionalAgendamentosPage({super.key});

  static const String route = '/profissional/agendamentos';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfissionalAgendamentosController>(
          create: (context) {
            final consultasProvider = Provider.of<ConsultasProvider>(
              context,
              listen: false,
            );
            final profissionalProvider = Provider.of<ProfissionalProvider>(
              context,
              listen: false,
            );
            final authProvider = Provider.of<AuthProvider>(
              context,
              listen: false,
            );

            return ProfissionalAgendamentosController(
              consultasProvider,
              authProvider,
              profissionalProvider: profissionalProvider,
            )..init();
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const _ProfissionalAgendamentosPageContent(),
      ),
    );
  }
}

class _ProfissionalAgendamentosPageContent extends StatelessWidget {
  const _ProfissionalAgendamentosPageContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfissionalAgendamentosController>();
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CalendarWidget(controller: controller),
            const SizedBox(height: 20),
            EventsListWidget(controller: controller),
          ],
        ),
      ),
    );
  }
}
