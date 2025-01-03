import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/src/cart/domain/entities/cart_product.dart';
import 'package:ecomly/src/cart/presentation/app/cart_product_riverpod_notifier/cart_product_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';

class CheckoutAllToggleButton extends ConsumerStatefulWidget {
  const CheckoutAllToggleButton({required this.allProducts, super.key});

  final List<CartProduct> allProducts;

  @override
  ConsumerState createState() => _CheckoutAllToggleButtonState();
}

class _CheckoutAllToggleButtonState
    extends ConsumerState<CheckoutAllToggleButton> {
  @override
  Widget build(BuildContext context) {
    final cartProductNotifier = ref.watch(cartProductNotifierProvider);
    final allProductsChecked =
        cartProductNotifier.length == widget.allProducts.length;
    return GestureDetector(
      onTap: () {
        if (allProductsChecked) {
          ref.read(cartProductNotifierProvider.notifier).deselectAll();
        } else {
          ref
              .read(cartProductNotifierProvider.notifier)
              .selectAll(widget.allProducts.map((product) => product.id));
        }
      },
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          allProductsChecked
              ? Colours.lightThemeSecondaryColour
              : Colors.transparent,
          BlendMode.srcATop,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Checkout all',
              style: TextStyles.paragraphSubTextRegular1.grey,
            ),
            const Gap(10),
            const Icon(
              IconlyLight.tick_square,
              color: Colours.lightThemeSecondaryTextColour,
            ),
          ],
        ),
      ),
    );
  }
}
