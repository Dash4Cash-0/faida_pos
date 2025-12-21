import 'package:faida_pos/widgets/checkout_widgets/checkout_button_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/discount_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/receipt_widget.dart';
import 'package:flutter/material.dart';

class CheckoutBottomSheet extends StatelessWidget {
  final int itemsCount;
  final String currentSaleItems;
  final ValueNotifier<double> storedValueNotifier;
  //final double storedValue;
  final VoidCallback onNewSale;
  final Function(String) addDiscount;

  const CheckoutBottomSheet({super.key,
    required this.itemsCount,
    required this.currentSaleItems,
    required this.storedValueNotifier,
    //required this.storedValue,
    required this.onNewSale,
    required this.addDiscount});

  @override
  Widget build(BuildContext context) {

    final controller = TextEditingController();

    return ValueListenableBuilder(
        valueListenable: storedValueNotifier,
        builder: (context, value, _) {
      return
        Container(
          height: 400,
          color: Colors.white,
          child: Stack(
              children: [
                Positioned(top: 0, left: 0, child: CloseButton()),
                Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text("Current Sale($itemsCount)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24)),
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
                          label: "Charge: ${storedValueNotifier.value} TZS",
                          onClicked: () =>
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      Dialog(
                                          backgroundColor: Colors.white,
                                          child: SizedBox(
                                            height: 320,
                                            width: 400,
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 56,
                                                        child: Stack(
                                                          alignment: Alignment
                                                              .center,
                                                          children: [
                                                            Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: CloseButton()
                                                            ),
                                                            Text(
                                                                "Amount Received",
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight
                                                                        .bold)),
                                                          ],
                                                        )
                                                    ),
                                                    SizedBox(height: 24),
                                                    TextField(
                                                      controller: controller,
                                                      decoration: InputDecoration(
                                                          border: UnderlineInputBorder(),
                                                          labelText: "Total price: ${storedValueNotifier.value} TZS"
                                                      ),
                                                    ),
                                                    SizedBox(height: 24),
                                                    Text("Add Discount"),
                                                    DiscountWidget(
                                                      onDiscountSelected: (
                                                          discount) {
                                                        addDiscount(discount);
                                                      },
                                                    ),
                                                    Spacer(),
                                                    CheckoutButtonWidget(
                                                      label: "Calculate Change",
                                                      onClicked: () =>
                                                          showDialog(
                                                              context: context,
                                                              builder: (
                                                                  BuildContext context) =>
                                                                  Dialog
                                                                      .fullscreen(
                                                                    child: ReceiptWidget(
                                                                        amountToPay: storedValueNotifier.value,
                                                                        onNewSale: onNewSale,
                                                                        amountReceived: double
                                                                            .tryParse(
                                                                            controller
                                                                                .text) ??
                                                                            0),
                                                                  )),
                                                    )
                                                  ],
                                                )),
                                          )
                                      )
                              ),
                        ))
                ),
              ]
          ),
        );
    }
    );
  }
}
