import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/models/sale_item.dart';
import 'package:faida_pos/widgets/checkout_widgets/checkout_button_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/discount_widget.dart';
import 'package:flutter/material.dart';

class CheckoutBottomSheet extends StatefulWidget {
  final int itemsCount;
  final List<SaleItem> currentSaleItems;
  final ValueNotifier<List<SaleItem>> saleItemNotifier;
  final ValueNotifier<double> storedValueNotifier;
  final VoidCallback onNewSale;
  final Function(String) addDiscount;
  final void Function(double amountReceived) onCalculate;

  const CheckoutBottomSheet({super.key,
    required this.itemsCount,
    required this.currentSaleItems,
    required this.storedValueNotifier,
    required this.saleItemNotifier,
    required this.onNewSale,
    required this.addDiscount,
    required this.onCalculate });


  @override
  State<CheckoutBottomSheet> createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  late final TextEditingController controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder(valueListenable: widget.storedValueNotifier,
        builder: (context, value, _) {
          return Container(height: 400, color: Colors.white,
              child: Stack(children: [
                Positioned(top: 0, left: 0, child: CloseButton()),
                Positioned.fill(child: Align(
                  alignment: Alignment.topCenter,
                  child: Text("${l10n.currentSale}(${widget.itemsCount})",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                )),
                Positioned(top: 60,
                    left: 0,
                    right: 0,
                    bottom: 80,
                    child: ValueListenableBuilder(
                        valueListenable: widget.saleItemNotifier,
                        builder: (context, items, _){
                          return SingleChildScrollView(
                          child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: items.map((item) {
                                    if(item.productId == null) {
                                      return Text("${item.name}: ${item.subtotal} TZS");
                                    }
                                    return Text("${item.name} x ${item.quantity}: ${item.subtotal} TZS");
                                  }).toList()
                              )),
                        );
                        }
                        )
                ),
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: CheckoutButtonWidget(
                          label: "${l10n.charge}: ${widget.storedValueNotifier.value} TZS",
                          onClicked: () => showDialog<String>(context: context, builder: (
                              BuildContext context) =>
                              Dialog(backgroundColor: Colors.white,
                                  child: Form( key: _formKey,
                                      child: SizedBox(height: 350, width: 400,
                                        child: Padding(padding: EdgeInsets.all(8.0),
                                            child: Column(children: [
                                              SizedBox(height: 56,
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Align(alignment: Alignment.centerLeft,
                                                          child: CloseButton()),
                                                      Text(l10n.amountReceived,
                                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                    ],
                                                    )
                                                ),
                                              SizedBox(height: 8),
                                              ValueListenableBuilder<double>
                                                (valueListenable: widget.storedValueNotifier,
                                                  builder: (context, total, _) {
                                                  return TextFormField(
                                                    controller: controller,
                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    decoration: InputDecoration(border: UnderlineInputBorder(),
                                                      labelText: "${l10n.totalPrice}: ${widget.storedValueNotifier.value} TZS",
                                                      errorMaxLines: 3
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "You need to enter the amount received";
                                                    }
                                                    final parsed = double.tryParse(value.trim());
                                                    if (parsed == null) {
                                                      return "Please enter a valid number";
                                                    }
                                                    if (parsed < widget.storedValueNotifier.value) {
                                                      return "Please enter: ${widget.storedValueNotifier.value} TZS or more";
                                                    }
                                                    return null;
                                                    },
                                                );
                                                    }),
                                                SizedBox(height: 12),
                                                Text(l10n.addDiscount),
                                                DiscountWidget(
                                                  onDiscountSelected: (discount) {
                                                      widget.addDiscount(discount);
                                                    },
                                                ),
                                                SizedBox(height: 12),
                                                CheckoutButtonWidget(
                                                    label: l10n.calculateChange,
                                                    onClicked: () {
                                                      if (_formKey.currentState?.validate() ==
                                                          true) {
                                                        final amount = double.tryParse(controller.text.trim());
                                                        if (amount != null) {
                                                          widget.onCalculate(amount);
                                                        }
                                                      }
                                                    }
                                                    ),
                                              ],
                                            )),
                                      )
                                  )
                              )
                          ),
                        )
                            )
                        ),
                      ]
                  )
              );
        }
    );
  }
}

