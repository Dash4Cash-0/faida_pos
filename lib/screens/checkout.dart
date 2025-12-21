import 'package:faida_pos/widgets/checkout_widgets/checkout_bottom_sheet.dart';
import 'package:faida_pos/widgets/checkout_widgets/checkout_button_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/favorites_tab/favorites_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/inventory_tab/inventory_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/numpad_tab_widget.dart';
import 'package:faida_pos/widgets/shared/tab_config.dart';
import 'package:faida_pos/widgets/shared/tabs_widget.dart';
import 'package:flutter/material.dart';
import 'package:faida_pos/utils/checkout_utils/charge_button_text.dart';


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
  final controller = TextEditingController();


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

  final List<String> _currentSaleList = [];

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

  void resetSale(){
    setState(() {
      storedValue = 0;
      input = "";
      partValues = "";
      _currentSaleList.clear();
    });
  }

  void addDiscount(String discount){

    setState(() {
      switch (discount) {
        case "5%":
          storedValue *= 0.95;
          break;
        case "10%":
          storedValue *= 0.90;
          break;
        case "15%":
          storedValue *=0.85;
          break;
        case "...":
          //_showCustomDialog();
          break;
      }
    }
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TabsWidget(tabs: const [
              TabConfig("Numpad"),
              TabConfig("Inventory"),
              TabConfig("Favorites")],
                currentIndex: _currentIndex,
                onSelectedTab: (index) {
              setState(() => _currentIndex = index);
                }),
            Expanded(child: tabs[_currentIndex]()),
            Align(alignment: Alignment.bottomCenter,
              child:
            CheckoutButtonWidget(label:
            getChargeButtonText(currentSaleList: _currentSaleList, input: input),
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
                      storedValue: storedValue,
                      onNewSale: resetSale,
                      addDiscount: addDiscount),
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

