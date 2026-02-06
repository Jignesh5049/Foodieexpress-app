class Address {
  final int? id;
  final String label;
  final String street;
  final String city;
  final String state;
  final String zip;
  final String instructions;
  final bool isDefault;

  const Address({
    this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    this.instructions = '',
    this.isDefault = false,
  });

  Address copyWith({
    int? id,
    String? label,
    String? street,
    String? city,
    String? state,
    String? zip,
    String? instructions,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      instructions: instructions ?? this.instructions,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      'instructions': instructions,
      'is_default': isDefault ? 1 : 0,
    };
  }

  static Address fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] as int?,
      label: map['label'] as String,
      street: map['street'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      zip: map['zip'] as String,
      instructions: (map['instructions'] as String?) ?? '',
      isDefault: (map['is_default'] as int? ?? 0) == 1,
    );
  }
}
