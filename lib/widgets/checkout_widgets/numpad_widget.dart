import 'package:flutter/material.dart';

class Numpad extends StatelessWidget {

  final Function(String) onNumberPressed;
  final VoidCallback onClearPressed;
  final VoidCallback onPlusPressed;

  const Numpad({super.key,
    required this.onNumberPressed,
    required this.onClearPressed,
  required this.onPlusPressed});


  @override
  Widget build(BuildContext context) {

    return
          GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 1.8,
          children: [
            ...List.generate(9, (index) {
              final number = (index + 1).toString();
              return numButton(number, () => onNumberPressed(number));
            }),
            
            numButton("C", onClearPressed),
            numButton("0", () => onNumberPressed("0")),
            numButton("+", onPlusPressed)
          ],
        );
  }

  Widget numButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey)
        ),
        child: Text(label, style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
