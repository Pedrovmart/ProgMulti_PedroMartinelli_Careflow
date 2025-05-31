import 'package:flutter/material.dart';
import '../../../widgets/styled_stat_card.dart';

class HomeStatsCards extends StatelessWidget {
  const HomeStatsCards({
    super.key,
    required this.patientCount,
    required this.consultationCount,
  });

  final String patientCount;
  final String consultationCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        Widget patientCard = StyledStatCard.patients(
          count: patientCount,
        );
        
        Widget consultationCard = StyledStatCard.consultations(
          count: consultationCount,
        );

        return Row(
          children: [
            Expanded(child: patientCard),
            const SizedBox(width: 12.0),
            Expanded(child: consultationCard),
          ],
        );
      },
    );
  }
}
