import 'package:faida_pos/services/database_service.dart';
import 'package:flutter/cupertino.dart';

class ReportsController extends ChangeNotifier {
  int sales = 0;
  int expenses = 0;
  int transactions = 0;
  int itemsSold = 0;
  int avgSale = 0;

  int get netProfit => sales - expenses;

  Future<void> load([DateTime? date]) async {
    final target = date ?? DateTime.now();
    final salesList = await DatabaseService.instance.getSalesByDate(target);
    final expensesList = await DatabaseService.instance.getExpensesByDate(target);

    sales = salesList.fold(0, (sum, s) => sum + s.total);
    expenses = expensesList.fold(0, (sum, e) => sum + e.expCost);
    transactions = salesList.length;
    avgSale = transactions > 0 ? sales ~/ transactions : 0;

    int totalItems = 0;
    for (final sale in salesList) {
      if (sale.id != null) {
        final items = await DatabaseService.instance.getSaleItems(sale.id!);
        totalItems += items.fold(0, (sum, item) => sum + item.quantity);
      }
    }
    itemsSold = totalItems;

    notifyListeners();
  }
}
