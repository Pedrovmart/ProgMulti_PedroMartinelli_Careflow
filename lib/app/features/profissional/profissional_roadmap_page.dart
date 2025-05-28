import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';

// TODO: Potentially import a shared AppBar widget if available
// import 'package:careflow_app/app/widgets/app_bars/default_app_bar_widget.dart';

class ProfissionalRoadmapPage extends StatefulWidget {
  const ProfissionalRoadmapPage({super.key});

  static const String route = '/profissional/roadmap';

  @override
  State<ProfissionalRoadmapPage> createState() => _ProfissionalRoadmapPageState();
}

class _ProfissionalRoadmapPageState extends State<ProfissionalRoadmapPage> {
  // TODO: Add logic to fetch and display patient cards for today's appointments
  // This will likely involve using a Provider (e.g., ConsultasProvider)
  // and filtering appointments for the current date.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Roadmap do Dia',
          style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        // centerTitle: true, // Uncomment if title should be centered
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Consultas Agendadas para Hoje:',
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryDark),
            ),
            const SizedBox(height: 20),
            // TODO: Replace this with a ListView.builder that displays patient cards
            // Each card should represent a patient with an appointment today.
            // Example: PatientCard(consulta: consultaModel)
            Expanded(
              child: Center(
                child: Text(
                  'Carregando consultas...', // Placeholder text
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}