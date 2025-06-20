import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/providers/consultas_provider.dart';
import '../../core/ui/app_text_styles.dart';
import '../../core/repositories/n8n_paciente_repository.dart'; 
import '../../core/http/n8n_http_client.dart'; 
import 'controllers/profissional_home_controller.dart';
import 'widgets/home_stats_cards.dart';
import '../../widgets/shared/upcoming_appointments_list.dart';
import '../../widgets/shared/upcoming_appointment_card.dart';
import '../../routes/routes.dart';

class ProfissionalHomePage extends StatefulWidget {
  const ProfissionalHomePage({super.key});

  static const String route = '/profissional/home';
  
  @override
  State<ProfissionalHomePage> createState() => _ProfissionalHomePageState();
}

class _ProfissionalHomePageState extends State<ProfissionalHomePage> {
  late final ProfissionalHomeController _controller;
  bool _isInitialized = false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initController();
      _isInitialized = true;
    }
  }
  
  void _initController() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final consultasProvider = Provider.of<ConsultasProvider>(context, listen: false);
    final httpClient = N8nHttpClient();
    final n8nPacienteRepository = N8nPacienteRepository(httpClient);
    
    _controller = ProfissionalHomeController(
      authProvider: authProvider,
      consultasProvider: consultasProvider,
      n8nPacienteRepository: n8nPacienteRepository,
    );
    
    _controller.addListener(_refreshUI);
    _controller.carregarDados();
  }
  
  void _refreshUI() {
    if (mounted) {
      setState(() {});
    }
  }
  
  @override
  void dispose() {
    _controller.removeListener(_refreshUI);
    super.dispose();
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsSection(context),
              const SizedBox(height: 24.0),
              _buildUpcomingAppointmentsSection(context),
              const SizedBox(height: 24.0),
              _buildQuickActionsSection(context),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return HomeStatsCards(
      patientCount: _controller.pacientesHoje,
      consultationCount: _controller.consultasTotal,
    );
  }

  Widget _buildUpcomingAppointmentsSection(BuildContext context) {
    final compromissosData = _controller.proximosCompromissos.map((compromisso) {
      final nomePaciente = compromisso["nome"] as String? ?? 'Paciente';
      return AppointmentCardData(
        imageUrl: compromisso["profileUrlImage"] as String? ?? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(nomePaciente)}&background=random&color=FFFFFF',
        title: 'Consulta com $nomePaciente',
        subtitle1: null, 
        subtitle2: compromisso["horario"] as String? ?? 'Horário indefinido',
        onTap: () {
          // TODO: Implement navigation to appointment details or patient profile
          log('Tapped appointment with $nomePaciente');
        },
      );
    }).toList();

    return UpcomingAppointmentsList(
      title: 'Próximos compromissos',
      appointments: compromissosData,
      isLoading: _controller.isLoading,
      emptyListMessage: 'Sua agenda está livre.',
      emptyListIcon: Icons.event_note_outlined,
      onSeeAll: () {
        // TODO: Implement navigation to full schedule page
        log('Tapped see all appointments');
      },
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 12.0),
          child: Text('Ações rápidas', style: AppTextStyles.headlineMedium),
        ),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                context: context,
                icon: Icons.route_rounded,
                label: 'Roadmap Clínico',
                backgroundColor: Theme.of(context).primaryColorDark,
                foregroundColor: Colors.white,
                onPressed: () => context.goNamed(Routes.profissionalRoadmapName),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: _buildQuickActionButton(
                context: context,
                icon: Icons.calendar_today_rounded,
                label: 'Agenda',
                backgroundColor: Theme.of(context).primaryColorDark,
                foregroundColor: Theme.of(context).primaryColorLight,
                onPressed: () => context.goNamed(Routes.profissionalAgendamentosName),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    Color? backgroundColor,
    Color? foregroundColor,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: 112,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColorLight,
              size: 20.0,
            ),
            const SizedBox(height: 8.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium.copyWith(
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
