import '../models/user.dart';
import 'local/app_database.dart';
import 'remote/auth_api.dart';

class AuthRepository {
  AuthRepository({required this.api, required this.database});

  final AuthApi api;
  final AppDatabase database;

  Future<User> login({required String email, required String password}) async {
    final user = await api.login(email: email, password: password);
    final merged = await _mergeWithLocalProfile(user);
    await database.upsertUserProfile(merged);
    return merged;
  }

  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = await api.signUp(name: name, email: email, password: password);
    final merged = await _mergeWithLocalProfile(user);
    await database.upsertUserProfile(merged);
    return merged;
  }

  Future<User> updateProfile(User user) async {
    await database.upsertUserProfile(user);
    return user;
  }

  Future<User?> getLocalUser() async {
    return database.getUserProfile();
  }

  Future<User> _mergeWithLocalProfile(User user) async {
    final local = await database.getUserProfile();
    if (local == null) {
      return user;
    }

    final sameIdentity = local.id == user.id || local.email == user.email;
    if (!sameIdentity) {
      return user;
    }

    return User(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone ?? local.phone,
      birthDate: user.birthDate ?? local.birthDate,
    );
  }
}
