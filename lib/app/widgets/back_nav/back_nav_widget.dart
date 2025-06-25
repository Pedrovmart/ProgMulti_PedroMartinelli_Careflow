import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';

class BackNavWidget extends StatelessWidget {
  final String? label;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onPressed;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  const BackNavWidget({
    super.key,
    this.label,
    this.backgroundColor = AppColors.primaryDark,
    this.iconColor = AppColors.light,
    this.textColor = AppColors.light,
    this.onPressed,
    this.iconSize = 24,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onPressed ?? () => context.pop(),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  offset: const Offset(0, 2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back_rounded,
                  color: iconColor,
                  size: iconSize,
                ),
                if (label != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    label!,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
