import 'package:faida_pos/widgets/shared/all_products.dart';
import 'package:flutter/material.dart';

class InventoryWidget extends StatelessWidget {
  const InventoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Expanded(child: AllProducts())
      ],
    );
  }
}
