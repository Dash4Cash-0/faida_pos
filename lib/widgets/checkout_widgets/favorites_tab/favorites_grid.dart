import 'package:flutter/material.dart';

class FavoritesGrid extends StatelessWidget {
  const FavoritesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.8,
        children: [
          ...List.generate(24, (index) {
            return addButton("+", () => Text("data"));
          }
          )
        ],

    );
  }

  Widget addButton (String label, VoidCallback onTap){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          border: Border.all(color: Colors.black)
        ),
        child: Text(
            label, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
