import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/ui/app_colors.dart';
import '../../core/ui/app_text_styles.dart';
import '../../widgets/shared/upcoming_appointments_list.dart';
import '../../widgets/shared/upcoming_appointment_card.dart';

class PacienteHomePage extends StatefulWidget {
  const PacienteHomePage({super.key});

  static const String route = '/paciente/home';

  @override
  State<PacienteHomePage> createState() => _PacienteHomePageState();
}

class _PacienteHomePageState extends State<PacienteHomePage> {
  // late final PacienteHomeController _controller; // You can initialize this if needed
  // bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // If you have a controller, initialize it here
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // _controller = PacienteHomeController(authProvider: authProvider);
    // _controller.carregarDados(); // Example method call
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(context, user?.displayName),
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
    // Placeholder: Replace with actual appointment data and logic from a controller
    bool isLoading = false; // Example state, should come from controller
    List<Map<String, String>> placeholderAppointments = [
      {
        'imageUrl': 'https://via.placeholder.com/150/011936/FFFFFF?Text=Dr.A',
        'name': 'Dr. Carlos Andrade',
        'specialty': 'Cardiologista',
        'time': 'Amanhã, 10:00',
      },
      {
        'imageUrl': 'https://via.placeholder.com/150/465362/FFFFFF?Text=Dr.B',
        'name': 'Dra. Ana Paula',
        'specialty': 'Dermatologista',
        'time': '20/07, 14:30',
      },
    ];

    final appointmentsData = placeholderAppointments.map((appt) {
      return AppointmentCardData(
        imageUrl: appt['imageUrl']!,
        title: appt['name']!,
        subtitle1: appt['specialty']!,
        subtitle2: appt['time']!,
        onTap: () {
          // TODO: Implement navigation to appointment details or professional profile
          // log('Tapped appointment with ${appt['name']}');
        },
      );
    }).toList();

    return UpcomingAppointmentsList(
      title: 'Próximas Consultas',
      appointments: appointmentsData,
      isLoading: isLoading, // This should come from a PacienteHomeController
      emptyListMessage: 'Você não possui consultas agendadas.',
      emptyListIcon: Icons.calendar_today_outlined,
      onSeeAll: () {
        // TODO: Implement navigation to full appointments list for patient
        // log('Tapped see all patient appointments');
      },
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
          childAspectRatio: 1.2, // Adjust as needed for button size
          children: [
            _buildQuickActionButton(
              context: context,
              icon: Icons.search_rounded,
              label: 'Buscar Profissionais',
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.light,
              onPressed: () {
                // TODO: Implement navigation
              },
            ),
            _buildQuickActionButton(
              context: context,
              icon: Icons.calendar_month_rounded,
              label: 'Agendar Consulta',
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              onPressed: () {
                // TODO: Implement navigation
              },
            ),
            _buildQuickActionButton(
              context: context,
              icon: Icons.receipt_long_rounded,
              label: 'Histórico Médico',
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              onPressed: () {
                // final PacienteHomeController controller = PacienteHomeController();
                // controller.navigateToHistoricoMedico(context);
              },
            ),
            _buildQuickActionButton(
              context: context,
              icon: Icons.person_outline_rounded,
              label: 'Meu Perfil',
              backgroundColor: AppColors.primaryDark,
              foregroundColor: AppColors.light,
              onPressed: () {
                // final PacienteHomeController controller = PacienteHomeController();
                // controller.navigateToPerfil(context);
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
        shadowColor: Colors.black.withOpacity(0.1),
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
