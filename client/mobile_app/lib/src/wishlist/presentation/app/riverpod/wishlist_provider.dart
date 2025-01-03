import 'package:ecomly/core/services/injection_container.dart';
import 'package:ecomly/src/wishlist/domain/usecases/add_to_wishlist.dart';
import 'package:ecomly/src/wishlist/domain/usecases/get_wishlist.dart';
import 'package:ecomly/src/wishlist/domain/usecases/remove_from_wishlist.dart';
import 'package:ecomly/src/wishlist/presentation/app/riverpod/wishlist_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wishlist_provider.g.dart';

@riverpod
class UserWishlist extends _$UserWishlist {
  @override
  WishlistState build([GlobalKey? familyKey]) {
    _getWishlist = sl<GetWishlist>();
    _addToWishlist = sl<AddToWishlist>();
    _removeFromWishlist = sl<RemoveFromWishlist>();
    return const WishlistInitial();
  }

  late GetWishlist _getWishlist;
  late AddToWishlist _addToWishlist;
  late RemoveFromWishlist _removeFromWishlist;

  Future<void> getWishlist(String userId) async {
    state = const GettingUserWishlist();
    final result = await _getWishlist(userId);
    result.fold(
      (failure) => state = WishlistError(failure.errorMessage),
      (wishlist) => state = FetchedUserWishlist(wishlist),
    );
  }

  Future<void> addToWishlist({
    required String userId,
    required String productId,
  }) async {
    state = const AddingToWishlist();
    final result = await _addToWishlist(
      AddToWishlistParams(userId: userId, productId: productId),
    );
    result.fold(
      (failure) => state = WishlistError(failure.errorMessage),
      (_) => state = const AddedToWishlist(),
    );
  }

  Future<void> removeFromWishlist({
    required String userId,
    required String productId,
  }) async {
    state = const RemovingFromWishlist();
    final result = await _removeFromWishlist(
      RemoveFromWishlistParams(userId: userId, productId: productId),
    );
    result.fold(
      (failure) => state = WishlistError(failure.errorMessage),
      (_) => state = const RemovedFromWishlist(),
    );
  }
}
