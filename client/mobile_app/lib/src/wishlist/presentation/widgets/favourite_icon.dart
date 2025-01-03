import 'package:ecomly/core/common/app/riverpod/current_user_provider.dart';
import 'package:ecomly/core/common/singletons/cache.dart';
import 'package:ecomly/core/extensions/widget_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/user/presentation/app/auth_user_provider.dart';
import 'package:ecomly/src/wishlist/presentation/app/riverpod/wishlist_provider.dart';
import 'package:ecomly/src/wishlist/presentation/app/riverpod/wishlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';

class FavouriteIcon extends ConsumerStatefulWidget {
  const FavouriteIcon({required this.productId, super.key});

  final String productId;

  @override
  ConsumerState<FavouriteIcon> createState() => _FavouriteIconState();
}

class _FavouriteIconState extends ConsumerState<FavouriteIcon> {
  final wishlistAdapterFamilyKey = GlobalKey();
  final authUserAdapterFamilyKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final authAdapter = ref.watch(authUserProvider(authUserAdapterFamilyKey));
    final wishlistAdapter = ref.watch(
      userWishlistProvider(wishlistAdapterFamilyKey),
    );
    final productIsFavourite =
        user!.wishlist.any((product) => product.productId == widget.productId);

    ref.listen(
      userWishlistProvider(wishlistAdapterFamilyKey),
      (previous, next) {
        if (next is WishlistError) {
          CoreUtils.showSnackBar(context, message: next.message);
        } else if (next is RemovedFromWishlist || next is AddedToWishlist) {
          CoreUtils.postFrameCall(() {
            ref
                .read(authUserProvider(authUserAdapterFamilyKey).notifier)
                .getUserById(Cache.instance.userId!);
          });
        }
      },
    );

    return IconButton(
      onPressed: () {
        if (productIsFavourite) {
          ref
              .read(userWishlistProvider(wishlistAdapterFamilyKey).notifier)
              .removeFromWishlist(
                userId: user.id,
                productId: widget.productId,
              );
        } else {
          ref
              .read(userWishlistProvider(wishlistAdapterFamilyKey).notifier)
              .addToWishlist(
                userId: user.id,
                productId: widget.productId,
              );
        }
      },
      icon: Icon(
        productIsFavourite ? IconlyBold.heart : IconlyBroken.heart,
        color: Colours.lightThemeSecondaryColour,
      ),
    ).loading(
      wishlistAdapter is AddingToWishlist ||
          wishlistAdapter is RemovingFromWishlist ||
          authAdapter is GettingUserData,
    );
  }
}
