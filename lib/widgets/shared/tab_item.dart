import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String tabLabel;
  final bool selectedTab;
  final VoidCallback onTap;

  const TabItem({
    super.key,
    required this.tabLabel,
    required this.selectedTab,
    required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(tabLabel, style: TextStyle(fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
