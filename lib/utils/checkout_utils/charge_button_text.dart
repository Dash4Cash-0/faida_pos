String getChargeButtonText({
  required List<String> currentSaleList,
  required String input}) {
  if (currentSaleList.length > 1) {
    return "Review ${currentSaleList.length} items";
  } else if (currentSaleList.length == 1 && input.isEmpty) {
    final total = currentSaleList.fold<double>(0, (sum, item) {
      final number = int.parse(item.split(": ")[1].split(" ")[0]);
      return sum + number;
    });
    return "Charge: $total TZS";
  } else if (input.isNotEmpty) {
    return "Charge: $input TZS";
  } else {
    return "Charge: 0 TZS";
  }
}