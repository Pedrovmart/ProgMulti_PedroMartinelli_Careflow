import 'package:careflow_app/app/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:careflow_app/app/models/profissional_model.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';

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
            child: SizedBox(height: 72.0), // Space for NavBarWidget
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 56.0), // Adjust FAB position due to custom NavBar
        child: FloatingActionButton.extended(
          onPressed: () {
            // TODO: Implementar navegação para agendamento
          },
          label: const Text('Agendar Consulta'),
          icon: const Icon(Icons.calendar_month_rounded), // Consistent icon
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.primaryDark,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(
      BuildContext context, Profissional profissional) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 280.0,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildProfileImage(profissional),
            _buildGradientOverlay(),
            _buildHeaderText(context, profissional),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(Profissional profissional) {
    if (profissional.profileUrlImage != null &&
        profissional.profileUrlImage!.isNotEmpty) {
      return Image.network(
        profissional.profileUrlImage!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
      );
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.primary.withOpacity(0.6),
      child: const Icon(Icons.person, size: 120, color: AppColors.light),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.transparent,
            Colors.black.withOpacity(0.8)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildHeaderText(BuildContext context, Profissional profissional) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profissional.nome,
            style: AppTextStyles.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profissional.especialidade,
            style: AppTextStyles.titleMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
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
            const SizedBox(height: 80), // Space for FAB
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
