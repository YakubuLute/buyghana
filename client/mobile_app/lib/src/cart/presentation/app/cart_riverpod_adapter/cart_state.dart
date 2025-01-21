part of 'cart_provider.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class AddingToCart extends CartState {
  const AddingToCart();
}

class ChangingCartProductQuantity extends CartState {
  const ChangingCartProductQuantity();
}

class FetchingCart extends CartState {
  const FetchingCart();
}

class FetchingCartCount extends CartState {
  const FetchingCartCount();
}

class FetchingCartProduct extends CartState {
  const FetchingCartProduct();
}

class RemovingFromCart extends CartState {
  const RemovingFromCart();
}

class InitiatingCheckout extends CartState {
  const InitiatingCheckout();
}

class AddedToCart extends CartState {
  const AddedToCart();
}

class ChangedCartProductQuantity extends CartState {
  const ChangedCartProductQuantity();
}

class CartFetched extends CartState {
  const CartFetched(this.cart);

  final List<CartProduct> cart;

  @override
  List<Object?> get props => cart;
}

class CartCountFetched extends CartState {
  const CartCountFetched(this.count);

  final int count;

  @override
  List<Object?> get props => [count];
}

class CartProductFetched extends CartState {
  const CartProductFetched(this.cartProduct);

  final CartProduct cartProduct;

  @override
  List<Object?> get props => [cartProduct];
}

class RemovedFromCart extends CartState {
  const RemovedFromCart();
}

class CheckoutInitiated extends CartState {
  const CheckoutInitiated(this.stripeCheckoutSessionUrl);

  final String stripeCheckoutSessionUrl;

  @override
  List<Object?> get props => [stripeCheckoutSessionUrl];
}

class CartError extends CartState {
  const CartError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
