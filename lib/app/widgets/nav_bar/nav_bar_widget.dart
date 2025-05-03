import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';

class NavBarWidget extends StatelessWidget {
  final Function(int) onTap;
  final int selectedIndex;

  const NavBarWidget({
    super.key,
    required this.onTap,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 76,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Ícone Home
            IconButton(
              icon: Icon(
                Icons.home,
                color: selectedIndex == 0 ? AppColors.accent : AppColors.light,
              ),
              onPressed: () => onTap(0),
            ),

            // Ícone Calendário
            IconButton(
              icon: Icon(
                Icons.calendar_today,
                color: selectedIndex == 1 ? AppColors.accent : AppColors.light,
              ),
              onPressed: () => onTap(1),
            ),

            // Ícone Busca
            IconButton(
              icon: Icon(
                Icons.search,
                color: selectedIndex == 2 ? AppColors.accent : AppColors.light,
              ),
              onPressed: () => onTap(2),
            ),

            // Ícone Roadmap
            IconButton(
              icon: Icon(
                Icons.map,
                color: selectedIndex == 3 ? AppColors.accent : AppColors.light,
              ),
              onPressed: () => onTap(3),
            ),

            // Ícone Perfil
            IconButton(
              icon: Icon(
                Icons.person,
                color: selectedIndex == 4 ? AppColors.accent : AppColors.light,
              ),
              onPressed: () => onTap(4),
            ),
          ],
        ),
      ),
    );
  }
}
