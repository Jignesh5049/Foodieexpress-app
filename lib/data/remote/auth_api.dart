import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../models/user.dart';

class AuthApi {
  AuthApi({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;
  final Duration _timeout = const Duration(seconds: 10);

  Future<User> login({required String email, required String password}) async {
    final data = await _postJson(
      path: '/auth/login',
      body: {'email': email, 'password': password},
      failureMessage: 'Login failed. Please check your credentials.',
    );
    return _parseUser(data);
  }

  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final data = await _postJson(
      path: '/auth/signup',
      body: {'name': name, 'email': email, 'password': password},
      failureMessage: 'Signup failed. Please try again.',
    );
    return _parseUser(data);
  }

  Future<Map<String, dynamic>> _postJson({
    required String path,
    required Map<String, dynamic> body,
    required String failureMessage,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw AuthException(failureMessage);
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    } on SocketException {
      throw AuthException(
        'Cannot reach the server. Check that your backend is running and '
        'the device can access $baseUrl.',
      );
    } on TimeoutException {
      throw AuthException(
        'Request timed out. Check that your backend is running and '
        'reachable at $baseUrl.',
      );
    } on FormatException {
      throw AuthException('Invalid response from server.');
    }
  }

  User _parseUser(Map<String, dynamic> data) {
    final userMap = data['user'] as Map<String, dynamic>;
    return User(
      id: userMap['id'] as String,
      name: userMap['name'] as String,
      email: userMap['email'] as String,
      phone: userMap['phone'] as String?,
      birthDate: userMap['birthDate'] as String?,
    );
  }
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}
