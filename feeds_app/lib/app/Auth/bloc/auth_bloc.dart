// lib/bloc/auth_bloc.dart
import 'package:feeds_app/app/Auth/repository/auth_repository.dart';
import 'package:feeds_app/app/Auth/services/storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

// lib/bloc/auth_bloc.dart (partial)
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final StorageService storageService;

  AuthBloc({required this.authRepository, required this.storageService})
    : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.login(
        phoneNumber: event.phoneNumber,
        password: event.password,
      );

      final User user = result['user'];
      final String token = result['token'];

      await storageService.saveToken(token);
      await storageService.saveUser(user); // Save the full user object

      emit(Authenticated(user, token));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final token = await storageService.getToken();
    final user = await storageService.getUser();

    if (token != null && user != null) {
      emit(Authenticated(user, token));
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final token = await storageService.getToken();

      if (token != null) {
        await authRepository.logout(token);
      }

      await storageService.clearToken();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.register(
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
        password: event.password,
      );
      emit(Registered(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
