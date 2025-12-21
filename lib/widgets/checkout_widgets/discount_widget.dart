import 'package:flutter/material.dart';

class DiscountWidget extends StatelessWidget {
  
  final Function(String) onDiscountSelected;

  const DiscountWidget({
    super.key,
    required this.onDiscountSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        discountButton("5%",  Colors.yellow),
        discountButton("10%", Colors.yellowAccent),
        discountButton("15%", Colors.orange),
        discountButton("...", Colors.orangeAccent),
      ],
    );
  }

  Widget discountButton(String label,  Color bgColor) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(55, 45),
          backgroundColor: bgColor,
          side: BorderSide(color: Colors.black, style: BorderStyle.solid)
        ),
        onPressed: () => onDiscountSelected(label),
        child: Text(label, style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),));
  }
}
