import 'package:ecomly/core/usecase/usecase.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

class Register extends UsecaseWithParams<void, RegisterParams> {
  const Register(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(RegisterParams params) => _repo.register(
        name: params.name,
        password: params.password,
        email: params.email,
        phone: params.phone,
      );
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.name,
    required this.password,
    required this.email,
    required this.phone,
  });

  final String name;
  final String password;
  final String email;
  final String phone;

  @override
  List<dynamic> get props => [
        name,
        password,
        email,
        phone,
      ];
}
