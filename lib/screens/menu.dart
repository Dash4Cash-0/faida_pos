import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
        titleTextStyle: TextStyle(color: Colors.black ,fontWeight: FontWeight.bold, fontSize: 28),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
    );
  }
}