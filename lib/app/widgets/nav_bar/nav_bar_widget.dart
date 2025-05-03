import 'package:careflow_app/app/widgets/nav_bar/nav_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';

class NavBarWidget extends StatelessWidget {
  final Function(int) onTap;
  final int selectedIndex;
  final List<NavBarItem> items;

  const NavBarWidget({
    super.key,
    required this.onTap,
    required this.selectedIndex,
    required this.items,
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
          children:
              items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return IconButton(
                  icon: Icon(
                    item.icon,
                    color:
                        selectedIndex == index
                            ? AppColors.accent
                            : AppColors.light,
                  ),
                  onPressed: () => onTap(index),
                );
              }).toList(),
        ),
      ),
    );
  }
}
