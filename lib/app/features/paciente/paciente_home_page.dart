import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/ui/app_colors.dart';
import '../../core/ui/app_text_styles.dart';
import '../../widgets/shared/upcoming_appointments_list.dart';
import '../../core/providers/consultas_provider.dart';
import '../../core/repositories/n8n_profissional_repository.dart';
import 'paciente_home_controller.dart';

class PacienteHomePage extends StatefulWidget {
  const PacienteHomePage({super.key});

  static const String route = '/paciente/home';

  @override
  State<PacienteHomePage> createState() => _PacienteHomePageState();
}

class _PacienteHomePageState extends State<PacienteHomePage> {
  late PacienteHomeController _controller;
  bool _showAllAppointments = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    _controller = PacienteHomeController(
      consultasProvider: Provider.of<ConsultasProvider>(context, listen: false),
      profissionalRepository: Provider.of<N8nProfissionalRepository>(context, listen: false), 
      pacienteId: authProvider.currentUser!.uid, 
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ChangeNotifierProvider.value(
        value: _controller, 
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(context, user?.displayName),
              const SizedBox(height: 24.0),
              _buildUpcomingAppointmentsSection(context),
              const SizedBox(height: 24.0),
              _buildQuickActionsSection(context),
              const SizedBox(height: 70.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, String? userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Olá, ${userName ?? 'Paciente'}!',
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Como podemos te ajudar hoje?',
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildUpcomingAppointmentsSection(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<PacienteHomeController>(
        builder: (context, controller, child) {
          if (controller.error != null) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Erro ao carregar consultas: ${controller.error}\nPor favor, tente novamente mais tarde.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.accentDark), // Using accentDark as error color
                ),
              ),
            );
          }

          final appointmentsToShow = _showAllAppointments
              ? controller.upcomingAppointments
              : controller.upcomingAppointments.take(3).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UpcomingAppointmentsList(
                title: 'Próximas Consultas',
                appointments: appointmentsToShow,
                isLoading: controller.isLoading,
                emptyListMessage: 'Você não possui consultas agendadas.',
                emptyListIcon: Icons.calendar_today_outlined,
                onSeeAll: null, 
              ),
              if (!_showAllAppointments && controller.hasMoreUpcomingAppointments)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _showAllAppointments = true;
                        });
                      },
                      child: Text(
                        'Ver mais',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              if (_showAllAppointments && controller.hasMoreUpcomingAppointments)
                 Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _showAllAppointments = false;
                        });
                      },
                      child: Text(
                        'Ver menos',
                         style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 12.0),
          child: Text(
            'Ações Rápidas',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 1.2, 
          children: [
            _buildQuickActionButton(
              context: context,
              icon: Icons.search_rounded,
              label: 'Buscar Profissionais',
              backgroundColor: AppColors.light , 
              foregroundColor: AppColors.primaryDark,
              onPressed: () {
                _controller.navigateToBuscarProfissionais(context);
              },
            ),
            _buildQuickActionButton(
              context: context,
              icon: Icons.calendar_month_rounded,
              label: 'Agendar Consulta',
              backgroundColor: AppColors.light, 
              foregroundColor: AppColors.primaryDark, 
              onPressed: () {
                _controller.navigateToAgendarConsulta(context);
              },
            ),
            _buildQuickActionButton(
              context: context,
              icon: Icons.receipt_long_rounded,
              label: 'Histórico Médico',
              backgroundColor: AppColors.light, 
              foregroundColor: AppColors.primaryDark, 
              onPressed: () {
                _controller.navigateToHistoricoMedico(context);
              },
            ),
            _buildQuickActionButton(
              context: context,
              icon: Icons.person_outline_rounded,
              label: 'Meu Perfil',
              backgroundColor: AppColors.light,
              foregroundColor: AppColors.primaryDark,
              onPressed: () {
                _controller.navigateToPerfil(context);
              },
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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: foregroundColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 2.0,
        shadowColor: Colors.black.withValues(alpha: 0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32.0),
          const SizedBox(height: 8.0),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
