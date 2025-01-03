import 'package:ecomly/core/common/singletons/cache.dart';
import 'package:ecomly/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly/core/common/widgets/empty_data.dart';
import 'package:ecomly/core/common/widgets/search_button.dart';
import 'package:ecomly/core/res/media.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/dashboard/presentation/widgets/menu_icon.dart';
import 'package:ecomly/src/wishlist/presentation/app/riverpod/wishlist_provider.dart';
import 'package:ecomly/src/wishlist/presentation/app/riverpod/wishlist_state.dart';
import 'package:ecomly/src/wishlist/presentation/widgets/wishlist_product_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class WishlistView extends ConsumerStatefulWidget {
  const WishlistView({super.key});

  static const path = '/wishlist';

  @override
  ConsumerState<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends ConsumerState<WishlistView> {
  final wishlistAdapterFamilyKey = GlobalKey();

  Future<void> getUserWishlist() async {
    return ref
        .read(userWishlistProvider(wishlistAdapterFamilyKey).notifier)
        .getWishlist(Cache.instance.userId!);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wishlistAdapter = ref.watch(
      userWishlistProvider(wishlistAdapterFamilyKey),
    );
    ref.listen(userWishlistProvider(wishlistAdapterFamilyKey),
        (previous, next) {
      if (next is WishlistError) {
        CoreUtils.showSnackBar(
          context,
          message: '${next.message}\nPULL TO REFRESH',
        );
      }
    });
    return RefreshIndicator.adaptive(
      onRefresh: getUserWishlist,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Saved Items'),
          leading: const MenuIcon(),
          bottom: const AppBarBottom(),
          actions: const [SearchButton(padding: EdgeInsets.only(right: 10))],
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              if (wishlistAdapter is GettingUserWishlist) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colours.lightThemePrimaryColour,
                  ),
                );
              } else if (wishlistAdapter is FetchedUserWishlist) {
                if (wishlistAdapter.wishlist.isEmpty) {
                  return const EmptyData('No Saved Products');
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final product = wishlistAdapter.wishlist[index];
                    return WishlistProductTile(
                      product,
                      mainPageFamilyKey: wishlistAdapterFamilyKey,
                    );
                  },
                  separatorBuilder: (_, __) => const Gap(20),
                  itemCount: wishlistAdapter.wishlist.length,
                );
              } else if (wishlistAdapter is WishlistError) {
                return Center(child: Lottie.asset(Media.error));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
