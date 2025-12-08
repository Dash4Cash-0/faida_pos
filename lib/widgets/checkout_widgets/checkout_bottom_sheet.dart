import 'package:flutter/material.dart';

class CheckoutBottomSheet extends StatelessWidget {
  final int itemsCount;
  final String currentSaleItems;

  const CheckoutBottomSheet({super.key,
    required this.itemsCount,
    required this.currentSaleItems});

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
              bottom: 0,
              child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(8),
                child: Text(
                    currentSaleItems,
                    style: TextStyle(fontSize: 18))),

              )
          )
        ],
      ),
    );
  }
}
