import 'package:flutter/foundation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/address.dart';
import '../../models/order_history.dart';
import '../../models/payment_method.dart';
import '../../models/user.dart';
import 'objectbox_entities.dart';
import '../../objectbox.g.dart';

class AppDatabase {
  AppDatabase._internal();

  static final AppDatabase instance = AppDatabase._internal();
  static const String settingsWalletBalanceKey = 'wallet_balance';

  Store? _store;
  User? _webUser;
  final List<Address> _webAddresses = [];
  final List<PaymentMethod> _webPaymentMethods = [];
  final List<OrderHistory> _webOrderHistory = [];
  final Map<String, String> _webSettings = {};
  int _webAddressId = 1;
  int _webPaymentId = 1;
  int _webOrderId = 1;

  Future<Store> get store async {
    if (_store != null) {
      return _store!;
    }
    _store = await _initStore();
    return _store!;
  }

  Future<Store> _initStore() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'foodieexpress_objectbox');
    return openStore(directory: path);
  }

  Future<void> upsertUserProfile(User user) async {
    if (kIsWeb) {
      _webUser = user;
      return;
    }
    final box = (await store).box<UserProfileEntity>();
    final entity = UserProfileEntity.fromModel(user);
    box.put(entity);
  }

  Future<User?> getUserProfile() async {
    if (kIsWeb) {
      return _webUser;
    }
    final box = (await store).box<UserProfileEntity>();
    final entity = box.get(UserProfileEntity.primaryId);
    return entity?.toModel();
  }

  Future<List<Address>> getAddresses() async {
    if (kIsWeb) {
      return List<Address>.from(_webAddresses);
    }
    final box = (await store).box<AddressEntity>();
    final queryBuilder = box.query()
      ..order(AddressEntity_.id, flags: Order.descending);
    final query = queryBuilder.build();
    final entities = query.find();
    query.close();
    return entities.map((item) => item.toModel()).toList();
  }

  Future<int> insertAddress(Address address) async {
    if (kIsWeb) {
      final newAddress = address.copyWith(id: _webAddressId++);
      _webAddresses.insert(0, newAddress);
      return newAddress.id ?? 0;
    }
    final box = (await store).box<AddressEntity>();
    final entity = AddressEntity.fromModel(address);
    return box.put(entity);
  }

  Future<int> updateAddress(Address address) async {
    if (kIsWeb) {
      if (address.id == null) {
        return 0;
      }
      final index = _webAddresses.indexWhere((item) => item.id == address.id);
      if (index == -1) {
        return 0;
      }
      _webAddresses[index] = address;
      return 1;
    }
    if (address.id == null) {
      return 0;
    }
    final box = (await store).box<AddressEntity>();
    final entity = AddressEntity.fromModel(address);
    box.put(entity);
    return 1;
  }

  Future<int> deleteAddress(int id) async {
    if (kIsWeb) {
      _webAddresses.removeWhere((item) => item.id == id);
      return 1;
    }
    final box = (await store).box<AddressEntity>();
    return box.remove(id) ? 1 : 0;
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    if (kIsWeb) {
      return List<PaymentMethod>.from(_webPaymentMethods);
    }
    final box = (await store).box<PaymentMethodEntity>();
    final queryBuilder = box.query()
      ..order(PaymentMethodEntity_.id, flags: Order.descending);
    final query = queryBuilder.build();
    final entities = query.find();
    query.close();
    return entities.map((item) => item.toModel()).toList();
  }

  Future<int> insertPaymentMethod(PaymentMethod method) async {
    if (kIsWeb) {
      final newMethod = method.copyWith(id: _webPaymentId++);
      _webPaymentMethods.insert(0, newMethod);
      return newMethod.id ?? 0;
    }
    final box = (await store).box<PaymentMethodEntity>();
    final entity = PaymentMethodEntity.fromModel(method);
    return box.put(entity);
  }

  Future<int> updatePaymentMethod(PaymentMethod method) async {
    if (kIsWeb) {
      if (method.id == null) {
        return 0;
      }
      final index = _webPaymentMethods.indexWhere(
        (item) => item.id == method.id,
      );
      if (index == -1) {
        return 0;
      }
      _webPaymentMethods[index] = method;
      return 1;
    }
    if (method.id == null) {
      return 0;
    }
    final box = (await store).box<PaymentMethodEntity>();
    final entity = PaymentMethodEntity.fromModel(method);
    box.put(entity);
    return 1;
  }

  Future<int> deletePaymentMethod(int id) async {
    if (kIsWeb) {
      _webPaymentMethods.removeWhere((item) => item.id == id);
      return 1;
    }
    final box = (await store).box<PaymentMethodEntity>();
    return box.remove(id) ? 1 : 0;
  }

  Future<void> setSetting(String key, String value) async {
    if (kIsWeb) {
      _webSettings[key] = value;
      return;
    }
    final box = (await store).box<SettingEntity>();
    final query = box.query(SettingEntity_.key.equals(key)).build();
    final existing = query.findFirst();
    query.close();
    final entity = SettingEntity(id: existing?.id ?? 0, key: key, value: value);
    box.put(entity);
  }

  Future<String?> getSetting(String key) async {
    if (kIsWeb) {
      return _webSettings[key];
    }
    final box = (await store).box<SettingEntity>();
    final query = box.query(SettingEntity_.key.equals(key)).build();
    final entity = query.findFirst();
    query.close();
    return entity?.value;
  }

  Future<double> getWalletBalance() async {
    final value = await getSetting(settingsWalletBalanceKey);
    if (value == null) {
      return 0;
    }
    return double.tryParse(value) ?? 0;
  }

  Future<void> setWalletBalance(double amount) async {
    await setSetting(settingsWalletBalanceKey, amount.toStringAsFixed(2));
  }

  Future<List<OrderHistory>> getOrderHistory() async {
    if (kIsWeb) {
      return List<OrderHistory>.from(_webOrderHistory);
    }
    final box = (await store).box<OrderHistoryEntity>();
    final queryBuilder = box.query()
      ..order(OrderHistoryEntity_.id, flags: Order.descending);
    final query = queryBuilder.build();
    final entities = query.find();
    query.close();
    return entities.map((item) => item.toModel()).toList();
  }

  Future<int> insertOrderHistory(OrderHistory order) async {
    if (kIsWeb) {
      final newOrder = OrderHistory(
        id: _webOrderId++,
        createdAt: order.createdAt,
        total: order.total,
        itemsCount: order.itemsCount,
        addressLabel: order.addressLabel,
        paymentLabel: order.paymentLabel,
      );
      _webOrderHistory.insert(0, newOrder);
      return newOrder.id ?? 0;
    }
    final box = (await store).box<OrderHistoryEntity>();
    final entity = OrderHistoryEntity.fromModel(order);
    return box.put(entity);
  }
}
