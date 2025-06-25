import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';

class ProfileInfoWidget extends StatelessWidget {
  final Map<String, String> userInfo;
  final VoidCallback onEditTap;

  const ProfileInfoWidget({
    super.key,
    required this.userInfo,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Informações Pessoais',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.primary),
                  onPressed: onEditTap,
                  tooltip: 'Editar informações',
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            ...userInfo.entries.map((entry) => _buildInfoItem(entry.key, entry.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
