import 'package:flutter/material.dart';

class DiscountWidget extends StatelessWidget {
  
  final VoidCallback onClicked;

  const DiscountWidget({
    super.key,
    required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        discountButton("5%", onClicked, Colors.yellow),
        discountButton("10%", onClicked, Colors.yellowAccent),
        discountButton("15%", onClicked, Colors.orange),
        discountButton("...", onClicked, Colors.orangeAccent),
      ],
    );
  }

  Widget discountButton(String label, VoidCallback onClicked, Color bgColor) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(55, 45),
          backgroundColor: bgColor,
          side: BorderSide(color: Colors.black, style: BorderStyle.solid)
        ),
        onPressed: onClicked,
        child: Text(label, style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),));
  }
}
