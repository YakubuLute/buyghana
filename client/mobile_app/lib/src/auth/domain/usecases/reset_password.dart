import 'package:ecomly/core/usecase/usecase.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

class ResetPassword extends UsecaseWithParams<void, ResetPasswordParams> {
  const ResetPassword(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(ResetPasswordParams params) => _repo.resetPassword(
        email: params.email,
        newPassword: params.newPassword,
      );
}

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({
    required this.email,
    required this.newPassword,
  });

  final String email;
  final String newPassword;

  @override
  List<dynamic> get props => [email, newPassword];
}
