import 'package:faida_pos/widgets/checkout_widgets/checkout_button_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/discount_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/receipt_widget.dart';
import 'package:flutter/material.dart';

class CheckoutBottomSheet extends StatelessWidget {
  final int itemsCount;
  final String currentSaleItems;
  final double storedValue;
  final VoidCallback onNewSale;

  const CheckoutBottomSheet({super.key,
    required this.itemsCount,
    required this.currentSaleItems,
    required this.storedValue,
    required this.onNewSale});

  @override
  Widget build(BuildContext context) {

    final controller = TextEditingController();

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
                    onClicked: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          backgroundColor: Colors.white,
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              SizedBox(height: 250, width: 400),
                              Positioned(top: 0, left: 0, child: CloseButton()),
                              Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text("Amount Recieved",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  )),
                              Positioned.fill(child: Align(
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "Total price: $storedValue TZS"
                                ),
                                ),
                              )),
                              Positioned(bottom:70, child: DiscountWidget(onClicked: () => Text("Text"))),
                              Positioned.fill(child: Align( alignment: Alignment.bottomCenter,
                              child: CheckoutButtonWidget(label: "Calculate Change",
                                  onClicked: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) => Dialog.fullscreen(
                                        child: ReceiptWidget(amountToPay: storedValue, onNewSale: onNewSale, amountReceived: double.tryParse(controller.text) ?? 0),
                                      )),
                                  )
                                )
                              ),
                            ],
                          )),
                        )),
              ))
          ),
        ]
      ),
    );
  }
}
