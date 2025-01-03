import 'package:ecomly/core/usecase/usecase.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/cart/domain/repos/cart_repo.dart';
import 'package:equatable/equatable.dart';

class RemoveFromCart extends UsecaseWithParams<void, RemoveFromCartParams> {
  const RemoveFromCart(this._repo);

  final CartRepo _repo;

  @override
  ResultFuture<void> call(RemoveFromCartParams params) => _repo.removeFromCart(
        userId: params.userId,
        cartProductId: params.cartProductId,
      );
}

class RemoveFromCartParams extends Equatable {
  const RemoveFromCartParams({
    required this.userId,
    required this.cartProductId,
  });

  final String userId;
  final String cartProductId;

  @override
  List<dynamic> get props => [
        userId,
        cartProductId,
      ];
}
