import 'package:faida_pos/controllers/notification_controller.dart';
import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/widgets/shared/nav_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavbarBottom extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const NavbarBottom({
    super.key,
    required this.currentIndex,
    required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final checkNotifications = Provider.of<NotificationController>(context, listen: true);
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
              label: l10n.checkout,
              selected: currentIndex == 0,
              onTap: () => onTabSelected(0)),
          NavItem(icon: Icons.compare_arrows,
              label: l10n.transactions,
              selected: currentIndex == 1,
              onTap: () => onTabSelected(1)),
          NavItem(icon: Icons.file_copy,
              label: l10n.reports,
              selected: currentIndex == 2,
              onTap: () => onTabSelected(2)),
          NavItem(icon:
          checkNotifications.notifications.isEmpty
              ? Icons.notifications : Icons.notifications_active,
              label: l10n.notifications,
              selected: currentIndex == 3,
              hasNotification: checkNotifications.notifications.isNotEmpty,
              onTap: () => onTabSelected(3)),
          NavItem(icon: Icons.menu,
              label: l10n.menu,
              selected: currentIndex == 4,
              onTap: () => onTabSelected(4)),
        ],
      ),
    );
  }
}
