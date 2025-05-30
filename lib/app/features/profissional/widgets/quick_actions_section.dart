import 'package:flutter/material.dart';
import '../../../core/ui/app_text_styles.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
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