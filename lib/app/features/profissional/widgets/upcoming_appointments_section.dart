import 'package:flutter/material.dart';
import '../../../core/ui/app_colors.dart';
import '../../../core/ui/app_text_styles.dart';

class UpcomingAppointmentsSection extends StatelessWidget {
  const UpcomingAppointmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
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
}