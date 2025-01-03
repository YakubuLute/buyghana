import 'package:ecomly/core/usecase/usecase.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/cart/domain/entities/cart_product.dart';
import 'package:ecomly/src/cart/domain/repos/cart_repo.dart';
import 'package:equatable/equatable.dart';

class GetCartProduct
    extends UsecaseWithParams<CartProduct, GetCartProductParams> {
  const GetCartProduct(this._repo);

  final CartRepo _repo;

  @override
  ResultFuture<CartProduct> call(GetCartProductParams params) =>
      _repo.getCartProduct(
        userId: params.userId,
        cartProductId: params.cartProductId,
      );
}

class GetCartProductParams extends Equatable {
  const GetCartProductParams({
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
