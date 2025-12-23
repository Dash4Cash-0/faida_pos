String getChargeButtonText({
  required List<String> currentSaleList,
  required String input,
  required String review,
  required String items,
  required String charge}) {
  if (currentSaleList.length > 1) {
    return "$review ${currentSaleList.length} $items";
  } else if (currentSaleList.length == 1 && input.isEmpty) {
    final total = currentSaleList.fold<double>(0, (sum, item) {
      final number = int.parse(item.split(": ")[1].split(" ")[0]);
      return sum + number;
    });
    return "$charge: $total TZS";
  } else if (input.isNotEmpty) {
    return "$charge: $input TZS";
  } else {
    return "$charge: 0 TZS";
  }
}