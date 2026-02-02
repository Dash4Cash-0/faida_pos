import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {

  final String dateLabel;
  final String saleTotal;
  final VoidCallback onClicked;


  const MenuButton({
    super.key,
    required this.dateLabel,
    required this.saleTotal,
    required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Divider(height: 10, thickness: 2, indent: 0,endIndent: 0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            SizedBox(width: double.infinity,
            child:
              TextButton(
                onPressed: onClicked, style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16)
              ),
                child: Text(dateLabel, style: TextStyle(fontSize: 18)))),
                Text(saleTotal, style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
          ]),
          Divider(height: 10, thickness: 2, indent: 0,endIndent: 0),
        ],
      )
    );
  }
}
