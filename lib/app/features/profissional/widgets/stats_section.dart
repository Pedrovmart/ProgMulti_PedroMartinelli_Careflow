import 'package:flutter/material.dart';
import '../../../core/ui/app_colors.dart';
import '../../../core/ui/app_text_styles.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: AppColors.accentLight.withValues(alpha: 0.7),
          borderColor: AppColors.success,
          titleColor: AppColors.successDark,
          valueColor: AppColors.successDark,
        );

        if (isWide) {
          return GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: (constraints.maxWidth / 3) / 110,
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
      height: 110,
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
}