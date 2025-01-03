import 'package:ecomly/core/usecase/usecase.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/user/domain/entities/user.dart';
import 'package:ecomly/src/user/domain/repos/user_repo.dart';

class GetUser extends UsecaseWithParams<User, String> {
  const GetUser(this._repo);

  final UserRepo _repo;

  @override
  ResultFuture<User> call(String params) => _repo.getUser(params);
}
