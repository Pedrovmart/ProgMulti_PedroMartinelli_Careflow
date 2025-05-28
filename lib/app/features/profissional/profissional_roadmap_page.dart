import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';
import 'package:careflow_app/app/features/profissional/profissional_roadmap_controller.dart';


// TODO: Potentially import a shared AppBar widget if available
// import 'package:careflow_app/app/widgets/app_bars/default_app_bar_widget.dart';

class ProfissionalRoadmapPage extends StatelessWidget {
  const ProfissionalRoadmapPage({super.key});

  static const String route = '/profissional/roadmap';

  @override
  Widget build(BuildContext context) {
    // Idealmente, o provider seria injetado mais acima na árvore de widgets
    // ou através de um sistema de injeção de dependências.
    return ChangeNotifierProvider(
      create: (context) => ProfissionalRoadmapController(), // Adicionar dependências do controller se houver
      child: const _ProfissionalRoadmapView(),
    );
  }
}

class _ProfissionalRoadmapView extends StatelessWidget {
  const _ProfissionalRoadmapView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfissionalRoadmapController>();

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshConsultas(),
            tooltip: 'Atualizar Consultas',
          ),
        ],
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
            Expanded(
              child: _buildBodyContent(context, controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context, ProfissionalRoadmapController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Text(
          controller.errorMessage!,
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (controller.consultasDoDia.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma consulta agendada para hoje.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
        ),
      );
    }

    return ListView.builder(
      itemCount: controller.consultasDoDia.length,
      itemBuilder: (context, index) {
        final consulta = controller.consultasDoDia[index];
        // TODO: Substituir por um PatientCard widget mais elaborado
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: Text(
                (index + 1).toString(),
                style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark),
              ),
            ),
            title: Text(
              'Paciente ID: ${consulta.idPaciente}', // Usar nome do paciente quando disponível
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Horário: ${consulta.hora}\nQueixa: ${consulta.queixaPaciente}',
              style: AppTextStyles.bodyMedium,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
            onTap: () {
              // TODO: Implementar navegação para detalhes da consulta
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Detalhes da consulta ${consulta.id}')),
              );
            },
          ),
        );
      },
    );
  }
}