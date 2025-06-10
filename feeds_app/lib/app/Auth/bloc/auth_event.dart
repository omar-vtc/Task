abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String phoneNumber;
  final String password;

  LoginRequested({required this.phoneNumber, required this.password});
}

class RegisterRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String password;

  RegisterRequested({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.password,
  });
}

class CheckAuthStatus extends AuthEvent {}

class LogoutRequested extends AuthEvent {}
