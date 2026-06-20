class Sale {
  final int? id;
  final DateTime createdAt;
  final int total;
  final int amountReceived;
  final int change;

  Sale({
    this.id,
    required this.createdAt,
    required this.total,
    required this.amountReceived,
    required this.change
});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'total': total,
      'amountReceived': amountReceived,
      'change': change
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
   return Sale(
     id: map['id'],
     createdAt: DateTime.parse(map['createdAt']),
     total: (map['total'] as num).toInt(),
     amountReceived: (map['amountReceived'] as num).toInt(),
     change: (map['change'] as num).toInt(),
   );
  }
}