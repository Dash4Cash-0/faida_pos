import 'package:faida_pos/widgets/shared/tab_config.dart';
import 'package:faida_pos/widgets/shared/tab_item.dart';
import 'package:flutter/material.dart';

class TabsWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onSelectedTab;
  final List<TabConfig> tabs;
  
  const TabsWidget({
    super.key, 
    required this.currentIndex,
    required this.onSelectedTab,
    required this.tabs});

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
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];

          return TabItem(
              tabLabel: tab.tabLabel,
              selectedTab: currentIndex == index,
              onTap: () => onSelectedTab(index));
        })
      ),
    );
  }
}
