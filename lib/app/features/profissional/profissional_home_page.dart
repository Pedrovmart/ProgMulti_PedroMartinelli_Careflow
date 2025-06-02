import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/providers/consultas_provider.dart';
import '../../core/ui/app_colors.dart';
import '../../core/ui/app_text_styles.dart';
import 'controllers/profissional_home_controller.dart';
import 'widgets/home_stats_cards.dart';

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
    
    _controller = ProfissionalHomeController(
      authProvider: authProvider,
      consultasProvider: consultasProvider,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(4.0, 0, 4.0, 12.0),
          child: Text(
            'Próximos compromissos',
            style: AppTextStyles.headlineMedium,
          ),
        ),
        if (_controller.isLoading)
          const Center(child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ))
        else if (_controller.proximosCompromissos.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 3.0,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.event_busy_outlined,
                      size: 48,
                      color: AppColors.primaryDark,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sua agenda está livre hoje',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nenhum compromisso agendado para o dia',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ..._controller.proximosCompromissos.map((compromisso) {
            return Column(
              children: [
                _buildAppointmentItem(
                  context: context,
                  imageUrl: 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(compromisso["nome"])}&background=random',
                  name: 'Consulta com ${compromisso["nome"]}',
                  time: compromisso["horario"],
                ),
                const SizedBox(height: 12.0),
              ],
            );
          }),
      ],
    );
  }

  Widget _buildAppointmentItem({
    required BuildContext context,
    required String imageUrl,
    required String name,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 3.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 24.0, backgroundImage: NetworkImage(imageUrl)),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.titleMedium),
                Text(
                  time,
                  style: AppTextStyles.caption.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
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
                icon: Icons.search_rounded,
                label: 'Buscar paciente',
                backgroundColor: Theme.of(context).primaryColorDark,
                foregroundColor: Colors.white,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: _buildQuickActionButton(
                context: context,
                icon: Icons.add_circle_outline_rounded,
                label: 'Novo agendamento',
                backgroundColor: Theme.of(context).primaryColorDark,
                foregroundColor: Theme.of(context).primaryColorLight,
                onPressed: () {},
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
