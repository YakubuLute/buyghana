part of 'auth_user_provider.dart';

abstract class AuthUserState extends Equatable {
  const AuthUserState();

  @override
  List<Object?> get props => [];
}

class AuthUserInitial extends AuthUserState {
  const AuthUserInitial();
}

class GettingUserData extends AuthUserState {
  const GettingUserData();
}

class UpdatingUserData extends AuthUserState {
  const UpdatingUserData();
}

class GettingUserPaymentProfile extends AuthUserState {
  const GettingUserPaymentProfile();
}

class FetchedUser extends AuthUserState {
  const FetchedUser();
}

class UserUpdated extends AuthUserState {
  const UserUpdated();
}

class FetchedUserPaymentProfile extends AuthUserState {
  const FetchedUserPaymentProfile(this.paymentProfileUrl);

  final String paymentProfileUrl;

  @override
  List<Object?> get props => [paymentProfileUrl];
}

class AuthUserError extends AuthUserState {
  const AuthUserError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
