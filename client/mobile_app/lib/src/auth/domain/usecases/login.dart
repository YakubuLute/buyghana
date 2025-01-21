import 'package:buyghana/core/usecase/usecase.dart';
import 'package:buyghana/core/utils/typedefs.dart';
import 'package:buyghana/src/auth/domain/repos/auth_repo.dart';
import 'package:buyghana/src/user/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

class Login extends UsecaseWithParams<User, LoginParams> {
  const Login(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<User> call(LoginParams params) => _repo.login(
        email: params.email,
        password: params.password,
      );
}

class LoginParams extends Equatable {
  const LoginParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<dynamic> get props => [email, password];
}
