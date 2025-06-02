import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';
import 'package:careflow_app/app/features/profissional/consulta_detalhes_page.dart';
import 'package:careflow_app/app/features/profissional/profissional_roadmap_controller.dart';

class ProfissionalRoadmapPage extends StatelessWidget {
  const ProfissionalRoadmapPage({super.key});

  static const String route = '/profissional/roadmap';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfissionalRoadmapController>(
          create: (context) => ProfissionalRoadmapController(
            consultasProvider: Provider.of<ConsultasProvider>(context, listen: false),
            authProvider: Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
      ],
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
        final horaFormatada = _formatarHora(consulta.hora);
        final nomePaciente = consulta.nome.isNotEmpty 
            ? consulta.nome 
            : 'Paciente ${index + 1}';
            
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: AppColors.primaryLight.withValues(alpha: 0.5), width: 1.0),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConsultaDetalhesPage(
                    idProfissional: consulta.idMedico,
                    idPaciente: consulta.idPaciente,
                    nomePaciente: nomePaciente,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Ícone de relógio com horário
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: AppColors.primaryDark,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          horaFormatada,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Informações do paciente
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nomePaciente,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        if (consulta.queixaPaciente.isNotEmpty) ...[
                          const SizedBox(height: 4.0),
                          Text(
                            'Queixa: ${consulta.queixaPaciente}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.grey[700],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Ícone de seta
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  // Formata a hora para exibição (ex: "14:30" -> "14h30")
  String _formatarHora(String hora) {
    try {
      final partes = hora.split(':');
      if (partes.length >= 2) {
        final horaInt = int.tryParse(partes[0]) ?? 0;
        final minutoInt = int.tryParse(partes[1]) ?? 0;
        return '${horaInt.toString().padLeft(2, '0')}h${minutoInt.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      // Em caso de erro, retorna a hora original
    }
    return hora;
  }
}
