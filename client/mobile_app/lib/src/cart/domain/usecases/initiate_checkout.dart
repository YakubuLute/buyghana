import 'package:buyghana/core/usecase/usecase.dart';
import 'package:buyghana/core/utils/typedefs.dart';
import 'package:buyghana/src/cart/domain/entities/cart_product.dart';
import 'package:buyghana/src/cart/domain/repos/cart_repo.dart';
import 'package:equatable/equatable.dart';

class InitiateCheckout
    extends UsecaseWithParams<String, InitiateCheckoutParams> {
  const InitiateCheckout(this._repo);

  final CartRepo _repo;

  @override
  ResultFuture<String> call(InitiateCheckoutParams params) =>
      _repo.initiateCheckout(
        theme: params.theme,
        cartItems: params.cartItems,
      );
}

class InitiateCheckoutParams extends Equatable {
  const InitiateCheckoutParams({required this.theme, required this.cartItems});

  final String theme;
  final List<CartProduct> cartItems;

  @override
  List<Object?> get props => [theme, ...cartItems];
}
