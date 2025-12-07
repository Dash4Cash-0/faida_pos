import 'package:faida_pos/widgets/checkout_widgets/checkout_button_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/numpad_display_widget.dart';
import 'package:faida_pos/widgets/checkout_widgets/numpad_widget.dart';
import 'package:flutter/material.dart';


class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String value = "";
  String partValues = "";
  double storedValue = 0;
  bool plusPressed = false;



  void onNumPressed(String digit){
    setState (() => value += digit);
  }

  void onClear() {
    setState(() {
      value = "";
      storedValue = 0;
      plusPressed = false;
      partValues = "";
    });
  }

  void onPlusPressed(){
    setState(() {
      final current = double.parse(value);
      storedValue += current;
      partValues += "$value + ";
      value = "";
      plusPressed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NumpadDisplayWidget(value: value),
            Text("$partValues"),
            Text("Total: $storedValue TZS"),
            Expanded(
                child: Numpad(
                  onNumberPressed: onNumPressed,
                  onClearPressed: onClear,
                onPlusPressed: onPlusPressed)),
            //Spacer(),
            Align(alignment: Alignment.bottomCenter,
              child:
            CheckoutButtonWidget(label:
            "Charge: $storedValue TZS",
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
                            child: closeButton(),
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


  Widget closeButton() =>
    IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.close));
}

