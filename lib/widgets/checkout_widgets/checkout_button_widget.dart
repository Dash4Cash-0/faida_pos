import 'package:flutter/material.dart';

class CheckoutButtonWidget extends StatelessWidget {

  final String label;
  final VoidCallback onClicked;

  const CheckoutButtonWidget({
    super.key,
  required this.label,
  required this.onClicked});


  @override
  Widget build(BuildContext context) =>
      Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(300, 60),
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)
        ),
        onPressed: onClicked,
        child: Text(
            label,
            style: TextStyle(fontSize: 20, color: Colors.black)),
      ),
    );
}
