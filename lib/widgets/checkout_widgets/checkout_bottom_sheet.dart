import 'package:faida_pos/widgets/checkout_widgets/checkout_button_widget.dart';
import 'package:flutter/material.dart';

class CheckoutBottomSheet extends StatelessWidget {
  final int itemsCount;
  final String currentSaleItems;
  final double storedValue;

  const CheckoutBottomSheet({super.key,
    required this.itemsCount,
    required this.currentSaleItems,
    required this.storedValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(top: 0, left: 0,child: CloseButton()),
          Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text("Current Sale($itemsCount)",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              )
          ),
          Positioned(
              top: 60,
              left: 0,
              right: 0,
              bottom: 80,
              child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(8),
                child: Text(
                    currentSaleItems,
                    style: TextStyle(fontSize: 18))),
              )
          ),
          Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CheckoutButtonWidget(
                    label: "Charge: $storedValue TZS",
                    onClicked: () => Navigator.pop(context)),
              ))
        ],
      ),
    );
  }
}
