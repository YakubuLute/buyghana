import 'package:ecomly/core/usecase/usecase.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/cart/domain/repos/cart_repo.dart';
import 'package:equatable/equatable.dart';

class ChangeCartProductQuantity
    extends UsecaseWithParams<void, ChangeCartProductQuantityParams> {
  const ChangeCartProductQuantity(this._repo);

  final CartRepo _repo;

  @override
  ResultFuture<void> call(ChangeCartProductQuantityParams params) =>
      _repo.changeCartProductQuantity(
        userId: params.userId,
        cartProductId: params.cartProductId,
        newQuantity: params.newQuantity,
      );
}

class ChangeCartProductQuantityParams extends Equatable {
  const ChangeCartProductQuantityParams({
    required this.userId,
    required this.cartProductId,
    required this.newQuantity,
  });

  final String userId;
  final String cartProductId;
  final int newQuantity;

  @override
  List<dynamic> get props => [
        userId,
        cartProductId,
        newQuantity,
      ];
}
