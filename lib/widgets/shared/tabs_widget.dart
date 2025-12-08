import 'package:faida_pos/widgets/shared/tab_item.dart';
import 'package:flutter/material.dart';

class TabsWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onSelectedTab;
  
  const TabsWidget({
    super.key, 
    required this.currentIndex,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TabItem(tabLabel: "Numpad",
              selectedTab: currentIndex == 0,
              onTap: () => onSelectedTab(0)),
          TabItem(tabLabel: "Inventory",
              selectedTab: currentIndex == 1,
              onTap: () => onSelectedTab(1)),
          TabItem(tabLabel: "Favorites",
              selectedTab: currentIndex == 2,
              onTap: () => onSelectedTab(2)),
        ],
      ),
    );
  }
}
