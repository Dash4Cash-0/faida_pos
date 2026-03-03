class NotificationsModel {
  final int id;
  final int productId;
  final bool? isLowStock;
  final bool? isOutOfStock;
  final bool? isDismissed;
  final bool? isResolved;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final DateTime? dismissedAt;

  NotificationsModel({
    required this.id,
    required this.productId,
    this.isLowStock,
    this.isOutOfStock,
    this.isDismissed,
    this.isResolved,
    required this.createdAt,
    this.resolvedAt,
    this.dismissedAt

});

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'saleItemId': productId,
      'isLowStock': isLowStock,
      'isOutOfStock': isOutOfStock,
      'isDismissed': isDismissed,
      'isResolved': isResolved,
      'createdAt': createdAt,
      'resolvedAt': resolvedAt,
      'dismissedAt': dismissedAt
    };
  }

  factory NotificationsModel.fromMap(Map<String, dynamic> map){
    return NotificationsModel(
        id: map['id'] as int,
        productId: map['productId'],
        isLowStock: map['isLowStock'] == 1,
        isOutOfStock: map['isOutOfStock'] == 1,
        isDismissed: map['isDismissed'] == 1,
        isResolved: map['isResolved'] == 1,
        createdAt: map['createdAt'],
        resolvedAt: map['resolvedAt'],
        dismissedAt: map['dismissedAt']
    );
  }



}