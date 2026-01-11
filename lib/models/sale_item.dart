class SaleItem {
  final int? productId;
  final String name;
  final double price;
  final double quantity;

  double get subtotal => price * quantity;

  SaleItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity
});


}