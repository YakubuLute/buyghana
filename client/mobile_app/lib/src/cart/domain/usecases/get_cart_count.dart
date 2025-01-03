import 'package:ecomly/core/usecase/usecase.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/cart/domain/repos/cart_repo.dart';

class GetCartCount extends UsecaseWithParams<int, String> {
  const GetCartCount(this._repo);

  final CartRepo _repo;

  @override
  ResultFuture<int> call(String params) => _repo.getCartCount(params);
}
