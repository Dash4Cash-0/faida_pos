import 'package:faida_pos/widgets/checkout_widgets/checkout_button_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/favorites_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/inventory_widget.dart';
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
  bool plusPressed = false;
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

  void onNumPressed(String digit){
    setState (() => input += digit);
  }

  void onClear() {
    setState(() {
      input = "";
      storedValue = 0;
      plusPressed = false;
      partValues = "";
    });
  }

  void onPlusPressed(){
    setState(() {
      final current = double.parse(input);
      storedValue += current;
      partValues += "$input + ";
      input = "";
      plusPressed = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    if(partValues.split('+').length - 1 > 1){
      int count = '+'.allMatches(partValues).length;
      currentSale = "Review $count items";
    } else {
      currentSale = "Charge: $storedValue TZS";
    }

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
            currentSale,
                onClicked: () {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 400,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(alignment: Alignment.topLeft,
                            child: CloseButton(),
                          )
                        ],
                      ),
                    );
                  });
                })
            )
          ],
        ),
      ),
    );
  }
}

