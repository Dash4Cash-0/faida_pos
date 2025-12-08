import 'package:flutter/material.dart';

class TabsWidget extends StatelessWidget {
  final String tabLabel;
  final int currentIndex;
  final Function(int) onSelectedTab;
  
  const TabsWidget({
    super.key, 
    required this.currentIndex,
    required this.tabLabel,
    required this.onSelectedTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
