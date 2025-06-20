import 'package:careflow_app/app/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:careflow_app/app/models/profissional_model.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/features/consultas/pacientes_agendamentos_page.dart';

class ProfissionalPerfilPublicoPage extends StatelessWidget {
  const ProfissionalPerfilPublicoPage({super.key});

  static const String route = '/paciente/busca/perfilProfissional';

  @override
  Widget build(BuildContext context) {
    final profissional =
        ModalRoute.of(context)?.settings.arguments as Profissional?;

    if (profissional == null) {
      return Scaffold(
        body: const Center(
          child: Text('Dados do profissional não encontrados.'),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          _buildHeader(context, profissional),
          _buildBody(context, profissional),
          const SliverToBoxAdapter(
            child: SizedBox(height: 72.0), 
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 56.0), 
        child: FloatingActionButton.extended(
          onPressed: () {
            context.push(
              PacientesAgendamentosPage.route,
              extra: {'profissional': profissional},
            );
          },
          label: const Text('Agendar Consulta'),
          icon: const Icon(Icons.calendar_month_rounded), 
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.primaryDark,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(
      BuildContext context, Profissional profissional) {
    final ThemeData theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCircleAvatar(profissional),
            const SizedBox(height: 16.0),
            Text(
              profissional.nome,
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineSmall.copyWith(
                color: theme.colorScheme.onSurface, 
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              profissional.especialidade,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8), 
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleAvatar(Profissional profissional) {
    return CircleAvatar(
      radius: 64, 
      backgroundColor: AppColors.light.withValues(alpha: 0.2), 
      backgroundImage: (profissional.profileUrlImage != null &&
              profissional.profileUrlImage!.isNotEmpty)
          ? NetworkImage(profissional.profileUrlImage!)
          : null,
      child: (profissional.profileUrlImage == null ||
              profissional.profileUrlImage!.isEmpty)
          ? Icon(
              Icons.person_rounded,
              size: 70,
              color: AppColors.primary.withValues(alpha: 0.8),
            )
          : null,
    );
  }

  SliverToBoxAdapter _buildBody(BuildContext context, Profissional profissional) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactCard(context, profissional),
            const SizedBox(height: 24),
            _buildAboutCard(context, profissional),
            const SizedBox(height: 80), 
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, Profissional profissional) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Informações de Contato', style: AppTextStyles.titleLarge),
            const SizedBox(height: 16),
            _buildInfoTile(
              icon: Icons.badge_outlined,
              label: 'Nº de Registro',
              value: profissional.numeroRegistro,
            ),
            const Divider(height: 24),
            _buildInfoTile(
              icon: Icons.email_outlined,
              label: 'Email',
              value: profissional.email,
            ),
            const Divider(height: 24),
            _buildInfoTile(
              icon: Icons.phone_outlined,
              label: 'Telefone',
              value: profissional.telefone ?? 'Não informado',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context, Profissional profissional) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sobre', style: AppTextStyles.titleLarge),
            const SizedBox(height: 16),
            Text(
              'Mais informações sobre o profissional estarão disponíveis em breve.',
              style: AppTextStyles.bodyLarge.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
      {required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.bodyMedium),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
