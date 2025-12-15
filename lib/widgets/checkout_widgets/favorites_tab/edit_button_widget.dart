import 'package:flutter/material.dart';

class EditButtonWidget extends StatelessWidget {
  const EditButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(100, 40),
            backgroundColor: Colors.white,
            side: BorderSide(color: Colors.black, style: BorderStyle.solid),
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)
        ),
        onPressed: () => Navigator.pop(context),
        child: Text("Edit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),));
  }
}
