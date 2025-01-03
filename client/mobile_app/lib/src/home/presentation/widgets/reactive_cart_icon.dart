import 'package:ecomly/core/common/singletons/cache.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/core/utils/global_keys.dart';
import 'package:ecomly/src/cart/presentation/app/cart_riverpod_adapter/cart_provider.dart';
import 'package:ecomly/src/cart/presentation/views/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

class ReactiveCartIcon extends ConsumerStatefulWidget {
  const ReactiveCartIcon({super.key});

  @override
  ConsumerState createState() => _HomeAppBarCartIconState();
}

class _HomeAppBarCartIconState extends ConsumerState<ReactiveCartIcon> {
  final countNotifier = ValueNotifier<int?>(null);
  final cartCountFamilyKey = GlobalKeys.cartCountFamilyKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartAdapterProvider(cartCountFamilyKey).notifier).getCartCount(
            Cache.instance.userId!,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      cartAdapterProvider(cartCountFamilyKey),
      (previous, next) {
        if (next is CartCountFetched) {
          CoreUtils.postFrameCall(() {
            countNotifier.value = next.count;
          });
        }
      },
    );

    return GestureDetector(
      onTap: () => context.push(CartView.path),
      child: ValueListenableBuilder(
          valueListenable: countNotifier,
          builder: (_, value, __) {
            return Badge(
              backgroundColor: Colours.lightThemeSecondaryColour,
              label: value == null
                  ? null
                  : Center(
                      child: Text(
                        value.toString(),
                        style: const TextStyle().white,
                      ),
                    ),
              child: Icon(
                IconlyBroken.buy,
                size: 24,
                color: Colours.classicAdaptiveTextColour(context),
              ),
            );
          }),
    );
  }
}
