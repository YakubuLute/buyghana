import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/wishlist/domain/entities/wishlist_product.dart';

abstract class WishlistRepo {
  ResultFuture<List<WishlistProduct>> getWishlist(String userId);
  ResultFuture<void> addToWishlist({
    required String userId,
    required String productId,
  });
  ResultFuture<void> removeFromWishlist({
    required String userId,
    required String productId,
  });
}
