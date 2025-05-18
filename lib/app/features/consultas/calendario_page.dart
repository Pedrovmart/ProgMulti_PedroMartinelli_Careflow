import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'calendario_controller.dart';
import 'widgets/calendar_widget.dart';
import 'widgets/events_list_widget.dart';
import 'widgets/form_widget.dart';

class CalendarioPage extends StatelessWidget {
  const CalendarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CalendarioController>(
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

            return CalendarioController(
              consultasProvider,
              profissionalProvider,
              authProvider,
            )..init();
          },
        ),
        // Garante que o ProfissionalProvider está disponível para os filhos
        ProxyProvider<CalendarioController, ProfissionalProvider>(
          update: (_, controller, __) => controller.profissionalProvider,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agendar Consulta'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const _CalendarioPageContent(),
      ),
    );
  }
}

class _CalendarioPageContent extends StatefulWidget {
  const _CalendarioPageContent();

  @override
  _CalendarioPageContentState createState() => _CalendarioPageContentState();
}

class _CalendarioPageContentState extends State<_CalendarioPageContent> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CalendarioController>();
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
