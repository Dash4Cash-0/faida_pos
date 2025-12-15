import 'package:faida_pos/widgets/checkout_widgets/checkout_bottom_sheet.dart';
import 'package:faida_pos/widgets/checkout_widgets/checkout_button_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/favorites_tab/favorites_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/inventory_tab/inventory_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/numpad_tab_widget.dart';
import 'package:faida_pos/widgets/shared/tabs_widget.dart';
import 'package:flutter/material.dart';


class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String input = "";
  String partValues = "";
  double storedValue = 0;
  int _currentIndex = 0;
  String currentSale = "";


  late final tabs = [
    () => NumpadTabWidget(onNumPressed: onNumPressed,
        onClear: onClear,
        onPlusPressed: onPlusPressed,
        value: input,
        partValues: partValues,
        storedValue: storedValue),
    () => InventoryWidget(),
    () => FavoritesWidget(),
  ];

  final _currentSaleList = [];

  void onNumPressed(String digit){
    setState (() {
      input += digit;
    });
  }

  void onClear() {
    setState(() {
      input = "";
      storedValue = 0;
      partValues = "";
      _currentSaleList.clear();
    });
  }

  void onPlusPressed(){
    if(input.isEmpty) return;
    setState(() {
      final current = double.parse(input);
      storedValue += current;
      _currentSaleList.add("Custom Amount: $input TZS");
      input = "";
    });
  }

  String getChargeButtonText() {
    if (_currentSaleList.length > 1) {
      return "Review ${_currentSaleList.length} items";
    } else if (_currentSaleList.length == 1 && input.isEmpty) {
      final total = _currentSaleList.fold<double>(0, (sum, item) {
        final number = int.parse(item.split(": ")[1].split(" ")[0]);
        return sum + number;
      });
      return "Charge: $total TZS";
    } else if (input.isNotEmpty) {
      return "Charge: $input TZS";
    } else {
      return "Charge: 0 TZS";
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TabsWidget(currentIndex: _currentIndex,
                onSelectedTab: (index) {
              setState(() => _currentIndex = index);
                }),
            Expanded(child: tabs[_currentIndex]()),
            Align(alignment: Alignment.bottomCenter,
              child:
            CheckoutButtonWidget(label:
            getChargeButtonText(),
                onClicked: () {
              if(input.isNotEmpty){
                setState(() {
                  final customAmount = double.parse(input);
                  storedValue += customAmount;
                  _currentSaleList.add("Custom Amount: $input TZS");
                  input = "";
                });
              }
              showModalBottomSheet(
                  context: context,
                  builder: (_) =>
                    CheckoutBottomSheet(
                      itemsCount: _currentSaleList.length,
                      currentSaleItems: _currentSaleList.join('\n'),
                      storedValue: storedValue),
                  );
                  }
                )
            )
          ],
        ),
      ),
    );
  }
}

