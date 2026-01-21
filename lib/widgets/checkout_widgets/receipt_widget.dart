import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/models/sale_item.dart';
import 'package:flutter/material.dart';


class ReceiptWidget extends StatelessWidget {
  final double amountToPay;
  final double amountReceived;
  final VoidCallback onNewSale;
  final ValueNotifier<List<SaleItem>> soldProducts;

  const ReceiptWidget({
    super.key,
    required this.amountToPay,
    required this.amountReceived,
    required this.onNewSale,
    required this.soldProducts});
  
  
  double calcChange() {
    double change = 0;
    if(amountToPay < amountReceived) {
      change = amountReceived - amountToPay;
    }
    return change;
  }
  
  String getSellCompleted(double amount, String completed, String change){
    if(amount == 0){
      return "$completed!";
    }else{
      return "$change: TZS ${amount.toStringAsFixed(0)}";
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
          Text(l10n.receipt,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 28)),
          Align(
            alignment: Alignment.center,
            child: Text(getSellCompleted(calcChange(),
                l10n.transactionCompleted,
                l10n.cashback),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          ),
          Expanded(child: ValueListenableBuilder(
              valueListenable: soldProducts,
              builder: (context, items, _) {
                if(items.isEmpty){
                  return Text(l10n.noItems);
                }

                return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_,__) => Divider(),
                    itemBuilder: (context, index){
                      final item = items[index];

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(
                            item.productId == null
                                ? item.name : "${item.name} x ${item.quantity}",
                            style: TextStyle(fontSize: 10),
                          )
                          ),
                          Text("TZS ${item.subtotal.toStringAsFixed(0)}",
                          style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      );
                    }
                    );
              })),

               ElevatedButton(
                  onPressed: () {
                    onNewSale();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                   style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.white,
                       foregroundColor: Colors.black,
                       side: BorderSide(
                           color: Colors.black,
                           width: 1,
                           style: BorderStyle.solid)),
                  child: Text(l10n.newSale))
        ],
      ),
    );
  }
}
