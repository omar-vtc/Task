import '../models/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  final String token;

  Authenticated(this.user, this.token);
}

class Registered extends AuthState {
  final User user;

  Registered(this.user);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
