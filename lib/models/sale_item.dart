class SaleItem {
  final int? id;
  final int? saleId;
  final int? productId;
  final String name;
  final double price;
  final double quantity;

  double get subtotal => price * quantity;

  SaleItem({
    this.id,
    this.saleId,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity
});

  factory SaleItem.fromMap(Map<String, dynamic> map){
    return SaleItem(
        id: map['id'] as int?,
        saleId: map['saleId'] as int?,
        productId: map['productId'] as int?,
        name: map['name'] as String,
        price: (map['price'] as num).toDouble(),
        quantity: (map['quantity'] as num).toDouble(),
    );
  }

}