part of 'auth_provider.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class OTPSent extends AuthState {
  const OTPSent();
}

class LoggedIn extends AuthState {
  const LoggedIn(this.user);

  final user_entity.User user;

  @override
  List<Object> get props => [user];
}

class Registered extends AuthState {
  const Registered();
}

class PasswordReset extends AuthState {
  const PasswordReset();
}

class OTPVerified extends AuthState {
  const OTPVerified();
}

class TokenVerified extends AuthState {
  const TokenVerified(this.isValid);

  final bool isValid;

  @override
  List<Object> get props => [isValid];
}

class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
