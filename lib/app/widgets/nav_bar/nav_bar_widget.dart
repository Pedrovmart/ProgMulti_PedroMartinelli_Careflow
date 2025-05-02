import 'package:flutter/material.dart';

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: selectedIndex == 0 ? Colors.blue : Colors.black,
              ),
              onPressed: () => onTap(0),
            ),
            IconButton(
              icon: Icon(
                Icons.calendar_today,
                color: selectedIndex == 1 ? Colors.blue : Colors.black,
              ),
              onPressed: () => onTap(1),
            ),
            IconButton(
              icon: Icon(
                Icons.person,
                color: selectedIndex == 2 ? Colors.blue : Colors.black,
              ),
              onPressed: () => onTap(2),
            ),
          ],
        ),
      ),
    );
  }
}
