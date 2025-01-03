import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/cart/domain/entities/cart_product.dart';

abstract class CartRepo {
  ResultFuture<List<CartProduct>> getCart(String userId);

  ResultFuture<int> getCartCount(String userId);

  ResultFuture<CartProduct> getCartProduct({
    required String userId,
    required String cartProductId,
  });

  ResultFuture<void> addToCart({
    required String userId,
    required CartProduct cartProduct,
  });

  ResultFuture<void> removeFromCart({
    required String userId,
    required String cartProductId,
  });

  ResultFuture<void> changeCartProductQuantity({
    required String userId,
    required String cartProductId,
    required int newQuantity,
  });

  ResultFuture<String> initiateCheckout({
    required String theme,
    required List<CartProduct> cartItems,
  });
}
