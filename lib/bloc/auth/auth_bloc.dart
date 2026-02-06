import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../models/user.dart';
import '../../data/auth_repository.dart';
import '../../data/remote/auth_api.dart';
import '../../data/local/app_database.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({AuthRepository? repository})
      : _repository = repository ??
            AuthRepository(
              api: AuthApi(baseUrl: _resolveBaseUrl()),
              database: AppDatabase.instance,
            ),
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }

  final AuthRepository _repository;

  static String _resolveBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    return 'http://192.168.6.18:3000';
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _repository.login(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
    } catch (error) {
      emit(AuthError(message: error.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _repository.signUp(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
    } catch (error) {
      emit(AuthError(message: error.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthUnauthenticated());
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthAuthenticated) {
      return;
    }

    final currentUser = (state as AuthAuthenticated).user;
    final updatedUser = User(
      id: currentUser.id,
      name: event.name,
      email: event.email,
      phone: event.phone,
      birthDate: event.birthDate,
    );

    try {
      final user = await _repository.updateProfile(updatedUser);
      emit(AuthAuthenticated(user: user));
    } catch (error) {
      emit(AuthAuthenticated(user: currentUser));
    }
  }
}
