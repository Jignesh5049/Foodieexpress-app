class PaymentMethod {
  final int? id;
  final String type;
  final String label;
  final String details;
  final bool isDefault;

  const PaymentMethod({
    this.id,
    required this.type,
    required this.label,
    required this.details,
    this.isDefault = false,
  });

  PaymentMethod copyWith({
    int? id,
    String? type,
    String? label,
    String? details,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      details: details ?? this.details,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'label': label,
      'details': details,
      'is_default': isDefault ? 1 : 0,
    };
  }

  static PaymentMethod fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] as int?,
      type: map['type'] as String,
      label: map['label'] as String,
      details: map['details'] as String,
      isDefault: (map['is_default'] as int? ?? 0) == 1,
    );
  }
}
