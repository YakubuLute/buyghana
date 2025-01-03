import 'package:ecomly/src/wishlist/domain/entities/wishlist_product.dart';
import 'package:equatable/equatable.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

class WishlistInitial extends WishlistState {
  const WishlistInitial();
}

class AddingToWishlist extends WishlistState {
  const AddingToWishlist();
}

class RemovingFromWishlist extends WishlistState {
  const RemovingFromWishlist();
}

class GettingUserWishlist extends WishlistState {
  const GettingUserWishlist();
}

class AddedToWishlist extends WishlistState {
  const AddedToWishlist();
}

class RemovedFromWishlist extends WishlistState {
  const RemovedFromWishlist();
}

class FetchedUserWishlist extends WishlistState {
  const FetchedUserWishlist(this.wishlist);

  final List<WishlistProduct> wishlist;

  @override
  List<Object> get props => wishlist;
}

class WishlistError extends WishlistState {
  const WishlistError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
