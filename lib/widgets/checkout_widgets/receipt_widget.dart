import 'package:flutter/material.dart';

class ReceiptWidget extends StatelessWidget {
  final double amountToPay;
  final double amountReceived;

  const ReceiptWidget({super.key, required this.amountToPay, required this.amountReceived});
  
  
  double calcChange() {
    double change = 0;
    if(amountToPay < amountReceived) {
      change = amountReceived - amountToPay;
    }
    return change;
  }
  
  String getSellCompleted(double amount){
    if(amount == 0){
      return "Transaction Completed!";
    }else{
      return "Customer is getting $amount TZS back";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(top: 0, left: 0,child: CloseButton()),
          Positioned.fill(child: Align(
            alignment: Alignment.center,
            child: Text(getSellCompleted(calcChange()), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          ))
        ],
      ),
    );
  }
}
