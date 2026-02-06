import 'package:objectbox/objectbox.dart';
import '../../models/address.dart';
import '../../models/order_history.dart';
import '../../models/payment_method.dart';
import '../../models/user.dart';

@Entity()
class UserProfileEntity {
  UserProfileEntity({
    this.id = primaryId,
    required this.userId,
    required this.name,
    required this.email,
    this.phone,
    this.birthDate,
  });

  @Id(assignable: true)
  int id;

  static const int primaryId = 1;

  @Unique()
  String userId;
  String name;
  String email;
  String? phone;
  String? birthDate;

  User toModel() {
    return User(
      id: userId,
      name: name,
      email: email,
      phone: phone,
      birthDate: birthDate,
    );
  }

  static UserProfileEntity fromModel(User user) {
    return UserProfileEntity(
      id: primaryId,
      userId: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      birthDate: user.birthDate,
    );
  }
}

@Entity()
class AddressEntity {
  AddressEntity({
    this.id = 0,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    this.instructions = '',
    this.isDefault = false,
  });

  @Id()
  int id;

  String label;
  String street;
  String city;
  String state;
  String zip;
  String instructions;
  bool isDefault;

  Address toModel() {
    return Address(
      id: id == 0 ? null : id,
      label: label,
      street: street,
      city: city,
      state: state,
      zip: zip,
      instructions: instructions,
      isDefault: isDefault,
    );
  }

  static AddressEntity fromModel(Address model) {
    return AddressEntity(
      id: model.id ?? 0,
      label: model.label,
      street: model.street,
      city: model.city,
      state: model.state,
      zip: model.zip,
      instructions: model.instructions,
      isDefault: model.isDefault,
    );
  }
}

@Entity()
class PaymentMethodEntity {
  PaymentMethodEntity({
    this.id = 0,
    required this.type,
    required this.label,
    required this.details,
    this.isDefault = false,
  });

  @Id()
  int id;

  String type;
  String label;
  String details;
  bool isDefault;

  PaymentMethod toModel() {
    return PaymentMethod(
      id: id == 0 ? null : id,
      type: type,
      label: label,
      details: details,
      isDefault: isDefault,
    );
  }

  static PaymentMethodEntity fromModel(PaymentMethod model) {
    return PaymentMethodEntity(
      id: model.id ?? 0,
      type: model.type,
      label: model.label,
      details: model.details,
      isDefault: model.isDefault,
    );
  }
}

@Entity()
class OrderHistoryEntity {
  OrderHistoryEntity({
    this.id = 0,
    required this.createdAt,
    required this.total,
    required this.itemsCount,
    required this.addressLabel,
    required this.paymentLabel,
  });

  @Id()
  int id;

  String createdAt;
  double total;
  int itemsCount;
  String addressLabel;
  String paymentLabel;

  OrderHistory toModel() {
    return OrderHistory(
      id: id == 0 ? null : id,
      createdAt: createdAt,
      total: total,
      itemsCount: itemsCount,
      addressLabel: addressLabel,
      paymentLabel: paymentLabel,
    );
  }

  static OrderHistoryEntity fromModel(OrderHistory model) {
    return OrderHistoryEntity(
      id: model.id ?? 0,
      createdAt: model.createdAt,
      total: model.total,
      itemsCount: model.itemsCount,
      addressLabel: model.addressLabel,
      paymentLabel: model.paymentLabel,
    );
  }
}

@Entity()
class SettingEntity {
  SettingEntity({this.id = 0, required this.key, required this.value});

  @Id()
  int id;

  @Unique()
  String key;
  String value;
}
