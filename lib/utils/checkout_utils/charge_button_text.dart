import 'package:faida_pos/models/sale_item.dart';

String getChargeButtonText({
  required List<SaleItem> currentSaleList,
  required String input,
  required String review,
  required String items,
  required String charge}) {
  if (currentSaleList.length > 1) {
    return "$review ${currentSaleList.length} $items";
  }

  if (currentSaleList.length == 1 && input.isEmpty) {
    final total = currentSaleList.first.subtotal;
    return "$charge: TZS $total";
  }

  if (input.isNotEmpty) {
    return "$charge: TZS $input";
  }

  return "$charge: TZS 0";
}