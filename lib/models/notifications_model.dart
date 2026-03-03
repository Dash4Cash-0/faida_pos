class NotificationsModel {
  final int id;
  final int saleItemId;
  final bool? isLowStock;
  final bool? isOutOfStock;
  final bool? isDismissed;
  final bool? isResolved;
  final DateTime createdAt;
  final DateTime resolvedAt;

  NotificationsModel({
    required this.id,
    required this.saleItemId,
    this.isLowStock,
    this.isOutOfStock,
    this.isDismissed,
    this.isResolved,
    required this.createdAt,
    required this.resolvedAt

});

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'saleItemId': saleItemId,
      'isLowStock': isLowStock,
      'isOutOfStock': isOutOfStock,
      'isDismissed': isDismissed,
      'isResolved': isResolved,
      'createdAt': createdAt,
      'resolvedAt': resolvedAt
    };
  }

  factory NotificationsModel.fromMap(Map<String, dynamic> map){
    return NotificationsModel(
        id: map['id'] as int,
        saleItemId: map['saleItemId'] as int,
        createdAt: map['createdAt'] as DateTime,
        resolvedAt: map['resolvedAt'] as DateTime
    );
  }



}