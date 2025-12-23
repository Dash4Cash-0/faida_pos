import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ReceiptWidget extends StatelessWidget {
  final double amountToPay;
  final double amountReceived;
  final VoidCallback onNewSale;

  const ReceiptWidget({
    super.key,
    required this.amountToPay,
    required this.amountReceived,
    required this.onNewSale});
  
  
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
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Align(alignment: Alignment.topLeft ,child: CloseButton()),
          Align(
            alignment: Alignment.center,
            child: Text(getSellCompleted(calcChange()), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          ),
               ElevatedButton(
                  onPressed: () {
                    onNewSale();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(l10n.newSale))
        ],
      ),
    );
  }
}
