import 'package:flutter/material.dart';

class NumpadDisplayWidget extends StatelessWidget {

  final String value;

  const NumpadDisplayWidget({super.key,
    required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.all(16),
      child: Text(value,
      style: TextStyle(fontSize: 30),
      ),
    );
  }
}

