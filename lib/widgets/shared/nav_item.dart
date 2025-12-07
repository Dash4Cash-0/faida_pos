import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
  required this.icon,
  required this.label,
  required this.selected,
  required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: selected ? Color(0xff000000):Color(0xff000000)),
          Text(label, style: TextStyle(color: selected ? Color(0xff000000):Color(0xff000000),
              fontWeight: FontWeight.bold, fontSize: 14))
        ],
      ),
    );
  }
}
