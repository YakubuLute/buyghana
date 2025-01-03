import 'package:ecomly/core/common/singletons/cache.dart';
import 'package:ecomly/core/extensions/int_extensions.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/cart/presentation/app/cart_riverpod_adapter/cart_provider.dart';
import 'package:ecomly/src/cart/presentation/widgets/cart_product_quantity_stepper_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartProductQuantityStepper extends ConsumerStatefulWidget {
  const CartProductQuantityStepper(
    this.initialQuantity, {
    required this.counterKey,
    required this.cartProductId,
    required this.onStep,
    super.key,
  });

  final int initialQuantity;
  final GlobalKey counterKey;
  final String cartProductId;
  final void Function(int? newQuantity) onStep;

  @override
  ConsumerState createState() => _CartProductQuantityStepperState();
}

class _CartProductQuantityStepperState
    extends ConsumerState<CartProductQuantityStepper> {
  late int initialQuantity;
  late ValueNotifier<int> quantityNotifier;

  void getCartProduct() {
    ref.read(cartAdapterProvider(widget.counterKey).notifier).getCartProduct(
          userId: Cache.instance.userId!,
          cartProductId: widget.cartProductId,
        );
  }

  @override
  void initState() {
    super.initState();
    initialQuantity = widget.initialQuantity;
    quantityNotifier = ValueNotifier(widget.initialQuantity)
      ..addListener(() {
        if (quantityNotifier.value != initialQuantity) {
          widget.onStep(quantityNotifier.value);
        } else {
          widget.onStep(null);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    final cartAdapter = ref.watch(cartAdapterProvider(widget.counterKey));
    ref.listen(
      cartAdapterProvider(widget.counterKey),
      (previous, next) {
        if (next is ChangedCartProductQuantity) {
          CoreUtils.postFrameCall(getCartProduct);
        } else if (next is CartError) {
          CoreUtils.showSnackBar(context, message: next.message);
          CoreUtils.postFrameCall(getCartProduct);
        } else if (next is CartProductFetched) {
          CoreUtils.postFrameCall(() {
            // I have to onStep here because when we fetch the fresh quantity
            // here and we update quantityNotifier.value, it doesn't trigger
            // it as at that point, they're essentially the same value

            // Now you might ask why do we need to do a re-fetch since it's
            // the same anyways both here and on the server after the update,
            // well, what if there's an error, when there's an error, we will
            // need this to be reset to whatever is the value on the server.

            // THIS MIGHT LEAD TO A RETRY LOOP THOUGH SO< BE CAREFUL HOW YOU
            // USE IT
            widget.onStep(null);
            initialQuantity = next.cartProduct.quantity;
            quantityNotifier.value = initialQuantity;
          });
        }
      },
    );
    if (cartAdapter is ChangingCartProductQuantity) {
      return const Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: Colours.lightThemePrimaryColour,
        ),
      );
    }
    return SizedBox(
      width: 127,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(90),
        child: ColoredBox(
          color: CoreUtils.adaptiveColour(
            context,
            lightModeColour: const Color(0xffEEEFF2),
            darkModeColour: Colours.darkThemeDarkSharpColour,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CartProductQuantityStepperIcon.decrement(
                onTap: () {
                  if (quantityNotifier.value > 1) {
                    quantityNotifier.value--;
                  }
                },
              ),
              ValueListenableBuilder(
                valueListenable: quantityNotifier,
                builder: (_, value, __) {
                  return Text(
                    value.pumpNumber,
                    style: TextStyles.paragraphSubTextRegular1
                        .adaptiveColour(context),
                  );
                },
              ),
              CartProductQuantityStepperIcon.increment(
                onTap: () {
                  quantityNotifier.value++;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
