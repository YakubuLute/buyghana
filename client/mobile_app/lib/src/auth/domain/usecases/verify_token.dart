import 'package:ecomly/core/usecase/usecase.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/auth/domain/repos/auth_repo.dart';

class VerifyToken extends UsecaseWithoutParams<bool> {
  const VerifyToken(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<bool> call() => _repo.verifyToken();
}
