import 'package:ecomly/core/common/singletons/cache.dart';
import 'package:ecomly/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly/core/common/widgets/search_button.dart';
import 'package:ecomly/core/extensions/int_extensions.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/media.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/core/utils/global_keys.dart';
import 'package:ecomly/src/cart/presentation/app/cart_product_riverpod_notifier/cart_product_notifier.dart';
import 'package:ecomly/src/cart/presentation/app/cart_riverpod_adapter/cart_provider.dart';
import 'package:ecomly/src/cart/presentation/utils/cart_utils.dart';
import 'package:ecomly/src/cart/presentation/widgets/cart_product_tile.dart';
import 'package:ecomly/src/cart/presentation/widgets/checkout_all_toggle_button.dart';
import 'package:ecomly/src/cart/presentation/widgets/checkout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';

class CartView extends ConsumerStatefulWidget {
  const CartView({super.key});

  static const path = '/cart';

  @override
  ConsumerState<CartView> createState() => _CartViewState();
}

class _CartViewState extends ConsumerState<CartView> {
  final cartAdapterFamilyKey = GlobalKeys.cartScreenAdapterFamilyKey;
  bool removingBulkProducts = false;

  Future<void> getCart() async {
    return ref
        .read(cartAdapterProvider(cartAdapterFamilyKey).notifier)
        .getCart(Cache.instance.userId!);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartAdapter = ref.watch(
      cartAdapterProvider(cartAdapterFamilyKey),
    );
    final cartProductNotifier = ref.watch(cartProductNotifierProvider);
    ref.listen(cartAdapterProvider(cartAdapterFamilyKey), (previous, next) {
      if (next is CartError) {
        CoreUtils.showSnackBar(
          context,
          message: '${next.message}\nPULL TO REFRESH',
        );
        if (previous is RemovingFromCart) {
          CoreUtils.postFrameCall(getCart);
        }
      } else if (next is RemovedFromCart) {
        CoreUtils.postFrameCall(getCart);
      }
    });
    return RefreshIndicator.adaptive(
      onRefresh: getCart,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Cart'),
          bottom: const AppBarBottom(),
          actions: [
            const SearchButton(),
            const Gap(5),
            if (cartProductNotifier.isNotEmpty)
              IconButton(
                onPressed: () async {
                  setState(() {
                    removingBulkProducts = true;
                  });
                  final shouldDelete = await CartUtils.verifyDeletion(
                    context,
                    message: 'Are you sure you want to remove these items?',
                  );

                  if (shouldDelete) {
                    for (final productId in cartProductNotifier) {
                      await ref
                          .read(cartAdapterProvider(cartAdapterFamilyKey)
                              .notifier)
                          .removeFromCart(
                            userId: Cache.instance.userId!,
                            cartProductId: productId,
                          );
                    }
                  }
                  setState(() {
                    removingBulkProducts = false;
                  });
                },
                icon: const Icon(IconlyBroken.delete),
                color: Colours.lightThemeSecondaryColour,
              ),
            const Gap(10),
          ],
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              if (removingBulkProducts) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colours.lightThemePrimaryColour,
                  ),
                );
              }
              if (cartAdapter is FetchingCart ||
                  cartAdapter is RemovingFromCart) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colours.lightThemePrimaryColour,
                  ),
                );
              } else if (cartAdapter is CartFetched) {
                if (cartAdapter.cart.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(Media.emptyCart, repeat: false),
                          const Gap(5),
                          Text(
                            'Oh! So empty',
                            style: TextStyles.headingSemiBold.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cartAdapter.cart.length.pluralizeWith('item'),
                            style: TextStyles.buttonTextHeadingSemiBold
                                .adaptiveColour(context),
                          ),
                          if (cartProductNotifier.isNotEmpty)
                            CheckoutAllToggleButton(
                              allProducts: cartAdapter.cart,
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartAdapter.cart.length,
                        itemBuilder: (context, index) {
                          final product = cartAdapter.cart[index];
                          return CartProductTile(
                            product,
                            mainPageFamilyKey: cartAdapterFamilyKey,
                          );
                        },
                        separatorBuilder: (_, __) => const Gap(20),
                      ),
                    ),
                    CheckoutButton(products: cartAdapter.cart),
                  ],
                );
              } else if (cartAdapter is CartError) {
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
