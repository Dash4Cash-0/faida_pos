class Expense {
  final int? id;
  final double expCost;
  final String expCategory;
  final String? expDesc;
  final DateTime createdAt;

  Expense({
    this.id,
    required this.expCost,
    required this.expCategory,
    this.expDesc,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expCost': expCost,
      'expCategory': expCategory,
      'expDesc': expDesc,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int,
      expCost: map['expCost'] as double,
      expCategory: map['expCategory'] as String,
      expDesc: map['expDesc'] as String?,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}