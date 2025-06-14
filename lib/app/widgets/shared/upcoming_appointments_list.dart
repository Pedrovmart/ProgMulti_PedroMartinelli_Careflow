import 'package:flutter/material.dart';
import '../../core/ui/app_colors.dart';
import '../../core/ui/app_text_styles.dart';
import 'upcoming_appointment_card.dart';

class UpcomingAppointmentsList extends StatelessWidget {
  final String title;
  final List<AppointmentCardData> appointments;
  final bool isLoading;
  final String emptyListMessage;
  final IconData emptyListIcon;
  final VoidCallback? onSeeAll;

  const UpcomingAppointmentsList({
    super.key,
    required this.title,
    required this.appointments,
    this.isLoading = false,
    this.emptyListMessage = 'Nenhum item encontrado.',
    this.emptyListIcon = Icons.event_busy_outlined,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primaryDark),
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  child: Text(
                    'Ver todos',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        ),
        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          )
        else if (appointments.isEmpty)
          _buildEmptyState(context)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: appointments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12.0),
            itemBuilder: (context, index) {
              return UpcomingAppointmentCard(data: appointments[index]);
            },
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyListIcon, size: 48, color: AppColors.primary.withOpacity(0.6)),
            const SizedBox(height: 16.0),
            Text(
              emptyListMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }
}
