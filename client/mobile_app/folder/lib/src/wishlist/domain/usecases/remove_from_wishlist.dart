import 'package:buyghana/core/usecase/usecase.dart';
import 'package:buyghana/core/utils/typedefs.dart';
import 'package:buyghana/src/wishlist/domain/repos/wishlist_repo.dart';
import 'package:equatable/equatable.dart';

class RemoveFromWishlist
    extends UsecaseWithParams<void, RemoveFromWishlistParams> {
  const RemoveFromWishlist(this._repo);

  final WishlistRepo _repo;

  @override
  ResultFuture<void> call(RemoveFromWishlistParams params) =>
      _repo.removeFromWishlist(
        userId: params.userId,
        productId: params.productId,
      );
}

class RemoveFromWishlistParams extends Equatable {
  const RemoveFromWishlistParams({
    required this.userId,
    required this.productId,
  });

  final String userId;
  final String productId;

  @override
  List<dynamic> get props => [
        userId,
        productId,
      ];
}
