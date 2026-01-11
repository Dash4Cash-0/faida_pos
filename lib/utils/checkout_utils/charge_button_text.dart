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
    return "$charge: $total TZS";
  }

  if (input.isNotEmpty) {
    return "$charge: $input TZS";
  }

  return "$charge: 0 TZS";
}