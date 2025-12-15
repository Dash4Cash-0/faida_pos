import 'package:faida_pos/widgets/checkout_widgets/favorites_tab/edit_button_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/favorites_tab/favorites_grid.dart';
import 'package:flutter/material.dart';

class FavoritesWidget extends StatelessWidget {
  const FavoritesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12),
          Align(
            alignment: Alignment.topRight,
            child: EditButtonWidget(),
    ),
        SizedBox(height: 12),
      Expanded(
          child: FavoritesGrid()
      ),
        SizedBox(height: 12)
    ],
    );
  }
}
