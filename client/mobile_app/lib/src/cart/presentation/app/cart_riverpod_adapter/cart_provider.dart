import 'package:ecomly/core/common/singletons/cache.dart';
import 'package:ecomly/core/services/injection_container.dart';
import 'package:ecomly/core/utils/global_keys.dart';
import 'package:ecomly/src/cart/domain/entities/cart_product.dart';
import 'package:ecomly/src/cart/domain/usecases/add_to_cart.dart';
import 'package:ecomly/src/cart/domain/usecases/change_cart_product_quantity.dart';
import 'package:ecomly/src/cart/domain/usecases/get_cart.dart';
import 'package:ecomly/src/cart/domain/usecases/get_cart_count.dart';
import 'package:ecomly/src/cart/domain/usecases/get_cart_product.dart';
import 'package:ecomly/src/cart/domain/usecases/initiate_checkout.dart';
import 'package:ecomly/src/cart/domain/usecases/remove_from_cart.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_provider.g.dart';

part 'cart_state.dart';

@riverpod
class CartAdapter extends _$CartAdapter {
  @override
  CartState build([GlobalKey? familyKey]) {
    _addToCart = sl<AddToCart>();
    _changeCartProductQuantity = sl<ChangeCartProductQuantity>();
    _getCart = sl<GetCart>();
    _getCartCount = sl<GetCartCount>();
    _getCartProduct = sl<GetCartProduct>();
    _removeFromCart = sl<RemoveFromCart>();
    _initiateCheckout = sl<InitiateCheckout>();
    return const CartInitial();
  }

  late AddToCart _addToCart;
  late ChangeCartProductQuantity _changeCartProductQuantity;
  late GetCart _getCart;
  late GetCartCount _getCartCount;
  late GetCartProduct _getCartProduct;
  late RemoveFromCart _removeFromCart;
  late InitiateCheckout _initiateCheckout;

  Future<void> addToCart({
    required String userId,
    required CartProduct cartProduct,
  }) async {
    state = const AddingToCart();

    final result = await _addToCart(
      AddToCartParams(userId: userId, cartProduct: cartProduct),
    );

    result.fold(
      (failure) => state = CartError(failure.errorMessage),
      (_) {
        state = const AddedToCart();
        ref
            .read(cartAdapterProvider(GlobalKeys.cartCountFamilyKey).notifier)
            .getCartCount(
              Cache.instance.userId!,
            );
      },
    );
  }

  Future<void> changeCartProductQuantity({
    required String userId,
    required String cartProductId,
    required int newQuantity,
  }) async {
    state = const ChangingCartProductQuantity();

    final result = await _changeCartProductQuantity(
      ChangeCartProductQuantityParams(
        userId: userId,
        cartProductId: cartProductId,
        newQuantity: newQuantity,
      ),
    );

    result.fold(
      (failure) => state = CartError(failure.errorMessage),
      (_) => state = const ChangedCartProductQuantity(),
    );
  }

  Future<void> getCart(String userId) async {
    state = const FetchingCart();

    final result = await _getCart(userId);

    result.fold(
      (failure) => state = CartError(failure.errorMessage),
      (cart) => state = CartFetched(cart),
    );
  }

  Future<void> getCartCount(String userId) async {
    state = const FetchingCartCount();

    final result = await _getCartCount(userId);

    result.fold(
      (failure) => state = CartError(failure.errorMessage),
      (count) => state = CartCountFetched(count),
    );
  }

  Future<void> getCartProduct({
    required String userId,
    required String cartProductId,
  }) async {
    state = const FetchingCartProduct();

    final result = await _getCartProduct(
      GetCartProductParams(userId: userId, cartProductId: cartProductId),
    );

    result.fold(
      (failure) => state = CartError(failure.errorMessage),
      (cartProduct) => state = CartProductFetched(cartProduct),
    );
  }

  Future<void> removeFromCart({
    required String userId,
    required String cartProductId,
  }) async {
    state = const RemovingFromCart();

    final result = await _removeFromCart(
      RemoveFromCartParams(userId: userId, cartProductId: cartProductId),
    );

    result.fold(
      (failure) => state = CartError(failure.errorMessage),
      (_) {
        state = const RemovedFromCart();
        ref
            .read(cartAdapterProvider(GlobalKeys.cartCountFamilyKey).notifier)
            .getCartCount(
              Cache.instance.userId!,
            );
      },
    );
  }

  Future<void> initiateCheckout({
    required String theme,
    required List<CartProduct> cartItems,
  }) async {
    state = const InitiatingCheckout();

    final result = await _initiateCheckout(
      InitiateCheckoutParams(theme: theme, cartItems: cartItems),
    );

    result.fold(
      (failure) => state = CartError(failure.errorMessage),
      (sessionUrl) => state = CheckoutInitiated(sessionUrl),
    );
  }
}
