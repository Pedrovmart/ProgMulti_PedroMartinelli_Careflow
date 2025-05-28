import 'package:flutter/material.dart';

import '../../core/ui/app_colors.dart';
import '../../core/ui/app_text_styles.dart';

class ProfissionalAgendamentosPage extends StatelessWidget {
  const ProfissionalAgendamentosPage({super.key});

  static const String route = '/profissional/agendamentos';

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
    ) 
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600;

        Widget item1 = _buildStatCard(
          context: context,
          title: 'Pacientes hoje',
          value: '12',
          backgroundColor: AppColors.accentLight.withValues(alpha: 0.7),
          borderColor: AppColors.accent,
          titleColor: AppColors.primaryDark,
          valueColor: AppColors.primaryDark,
        );
        Widget item2 = _buildStatCard(
          context: context,
          title: 'Consultas',
          value: '8',
          backgroundColor: AppColors.accentLight.withValues(alpha: 0.7),
          borderColor: AppColors.accent,
          titleColor: AppColors.primaryDark,
          valueColor: AppColors.primaryDark,
        );
        Widget item3 = _buildStatCard(
          context: context,
          title: 'Notificações',
          value: '3',
          backgroundColor: AppColors.light.withValues(
            alpha: 0.7,
          ), // Was amber, using AppColors.light (yellowish-green)
          borderColor:
              AppColors.success, // Was amber, using AppColors.success (green)
          titleColor:
              AppColors.successDark, // Was amber, using AppColors.successDark
          valueColor:
              AppColors.successDark, // Was amber, using AppColors.successDark
        );

        if (isWide) {
          return GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio:
                (constraints.maxWidth / 3) / 110, // Ajustar altura do card
            children: [item1, item2, item3],
          );
        } else {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: item1),
                  const SizedBox(width: 12.0),
                  Expanded(child: item2),
                ],
              ),
              const SizedBox(height: 12.0),
              SizedBox(width: double.infinity, child: item3),
            ],
          );
        }
      },
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required Color backgroundColor,
    required Color borderColor,
    required Color titleColor,
    required Color valueColor,
  }) {
    return Container(
      height: 110, // Aumentada para corrigir overflow e alinhar com aspect ratio do GridView
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 3.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMediumBold.copyWith(color: titleColor),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: AppTextStyles.displayLarge.copyWith(
              color: valueColor,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
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
        _buildAppointmentItem(
          context: context,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAKF6rkXdBXJ4B7HrcQqkfPwBkvgPQVxmVZ5YkUfMAL17CxDjJ2ue_Xn9Cu-AUNIkogQILX4E9peoxO9EboDlcrFuj8HV50bVhu4Jqb07yTzcOeaUfQHTssbqsqGI7-icZ46_6lcettz5BUQILDmWKVvlf_3Id_7unXrG2wz29WWU70NNn-Udgtiyx4z4-fHz-XKIfVEFULyoFK_YeZFzU1tHso-rRcWQA8sKWmCtVg0ElOPOC-eGaL988AOSAG4c7iXM3s__OKo-f9',
          name: 'Consulta com Maria Souza',
          time: '10:00 - 10:30',
        ),
        const SizedBox(height: 12.0),
        _buildAppointmentItem(
          context: context,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAAQBpZpD1npaBqR4bw3EPfFhZ78qvp7h6PAPBYaxmFk0f3-bFgjxfR4pHPdCeKXe6L0NnmKOBL1KYgCwmgh2m0u8Nu63aKi_qAO2PBeim8cTi-YhFSB9mv-07BDjYVTxdTCtjxwqYDDcXnbRQNFTzTZRdfuF0LoY0T9P7AcsV_mwzZYv9jDYt6tBRrwK9Sm6TcSWSrvuz620HFB80XN55QCg-6TjItgM5aQfSkJo_xpVQzYKzxiHoF7LqqYErHKl8PGAtPLOJyvVh2',
          name: 'Consulta com Carlos Mendes',
          time: '11:00 - 11:45',
        ),
        const SizedBox(height: 12.0),
        _buildAppointmentItem(
          context: context,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDdaNby_F915T3Z9oYsD1A7_DVdbHqQ6F-_fn_616WpW6nakjfO1hnFhVOOnikWrFTWTiDanjOMD5mHActITc3YUY1riXdNtpC5p4cu0iEoThpSJFPQIQvmhfPsIbAHFbcQQjddHG-kypAgfqTykaQ7b45lCvTJY_8gv657zWWHFjaXz4uy0ki2PFHLOPBCZJ4MbDX_N9X_zTX6N9upVVs0n59wyTHTrPb6OhJpeAV5sjhPsmV0LfyPItErv5eYI0LF-wwQ1-FwMzyX',
          name: 'Consulta com Ana Pereira',
          time: '13:00 - 13:30',
        ),
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
          const Icon(
            Icons.chevron_right_outlined,
            color: AppColors.primaryLight,
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
                backgroundColor: Theme.of(context)
                    .elevatedButtonTheme
                    .style
                    ?.backgroundColor
                    ?.resolve({WidgetState.selected}),
                foregroundColor: Theme.of(context)
                    .elevatedButtonTheme
                    .style
                    ?.foregroundColor
                    ?.resolve({WidgetState.selected}),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: _buildQuickActionButton(
                context: context,
                icon: Icons.add_circle_outline_rounded,
                label: 'Novo agendamento',
                backgroundColor: Theme.of(context)
                    .elevatedButtonTheme
                    .style
                    ?.backgroundColor
                    ?.resolve({WidgetState.selected}),
                foregroundColor: Theme.of(context)
                    .elevatedButtonTheme
                    .style
                    ?.foregroundColor
                    ?.resolve({WidgetState.selected}),
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
              color: Theme.of(context)
                  .elevatedButtonTheme
                  .style
                  ?.foregroundColor
                  ?.resolve({WidgetState.selected}),
              size: 20.0,
            ),
            const SizedBox(height: 8.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
