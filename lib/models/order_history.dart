class OrderHistory {
  final int? id;
  final String createdAt;
  final double total;
  final int itemsCount;
  final String addressLabel;
  final String paymentLabel;

  const OrderHistory({
    this.id,
    required this.createdAt,
    required this.total,
    required this.itemsCount,
    required this.addressLabel,
    required this.paymentLabel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt,
      'total': total,
      'items_count': itemsCount,
      'address_label': addressLabel,
      'payment_label': paymentLabel,
    };
  }

  static OrderHistory fromMap(Map<String, dynamic> map) {
    return OrderHistory(
      id: map['id'] as int?,
      createdAt: map['created_at'] as String,
      total: (map['total'] as num).toDouble(),
      itemsCount: map['items_count'] as int,
      addressLabel: map['address_label'] as String,
      paymentLabel: map['payment_label'] as String,
    );
  }
}
