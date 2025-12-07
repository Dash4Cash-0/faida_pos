import 'package:faida_pos/widgets/shared/nav_item.dart';
import 'package:flutter/material.dart';

class NavbarBottom extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const NavbarBottom({
    super.key,
    required this.currentIndex,
    required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xffD9D9D9),
        border: Border.all(color: Colors.black, width: 1)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavItem(icon: Icons.shopping_cart,
              label: "Checkout",
              selected: currentIndex == 0,
              onTap: () => onTabSelected(0)),
          NavItem(icon: Icons.compare_arrows,
              label: "Transactions",
              selected: currentIndex == 1,
              onTap: () => onTabSelected(1)),
          NavItem(icon: Icons.file_copy,
              label: "Reports",
              selected: currentIndex == 2,
              onTap: () => onTabSelected(2)),
          NavItem(icon: Icons.notifications,
              label: "Notifications",
              selected: currentIndex == 3,
              onTap: () => onTabSelected(3)),
          NavItem(icon: Icons.menu,
              label: "Menu",
              selected: currentIndex == 4,
              onTap: () => onTabSelected(4)),
        ],
      ),
    );
  }
}
