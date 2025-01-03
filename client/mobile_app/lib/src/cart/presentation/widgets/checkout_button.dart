import 'package:ecomly/core/common/widgets/rounded_button.dart';
import 'package:ecomly/core/extensions/context_extensions.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/extensions/widget_extensions.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/cart/domain/entities/cart_product.dart';
import 'package:ecomly/src/cart/presentation/app/cart_product_riverpod_notifier/cart_product_notifier.dart';
import 'package:ecomly/src/cart/presentation/app/cart_riverpod_adapter/cart_provider.dart';
import 'package:ecomly/src/cart/presentation/views/checkout_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutButton extends ConsumerStatefulWidget {
  const CheckoutButton({required this.products, super.key});

  final List<CartProduct> products;

  @override
  ConsumerState createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends ConsumerState<CheckoutButton> {
  final cartAdapterFamilyKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final cartProductNotifier = ref.watch(cartProductNotifierProvider);
    final cartAdapter = ref.watch(cartAdapterProvider(cartAdapterFamilyKey));

    final selectedProducts = widget.products.where(
      (product) => cartProductNotifier.contains(product.id),
    );
    double total = 0;
    if (cartProductNotifier.isEmpty) {
      total = widget.products.fold<double>(
        0,
        (value, product) => value + (product.productPrice * product.quantity),
      );
    } else {
      total = selectedProducts.fold<double>(
        0,
        (value, product) => value + (product.productPrice * product.quantity),
      );
    }

    ref.listen(cartAdapterProvider(cartAdapterFamilyKey), (previous, next) {
      if (next is CheckoutInitiated) {
        final url = next.stripeCheckoutSessionUrl;
        CoreUtils.postFrameCall(() async {
          if (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS) {
            context.push(CheckoutView.path, extra: url);
          } else {
            if (!await launchUrl(Uri.parse(url))) {
              debugPrint('ERROR: Could not launch Stripe checkout url');
              if (!mounted) return;
              CoreUtils.showSnackBar(
                context,
                message: 'Error Occurred, '
                    'Please try again.\nIf issue persists, contact support.',
              );
            }
          }
        });
      } else if (next is CartError) {
        CoreUtils.showSnackBar(context, message: next.message);
      }
    });

    return Padding(
      padding: const EdgeInsets.all(20).copyWith(bottom: 40),
      child: RoundedButton(
        height: 50,
        onPressed: () {
          ref
              .read(cartAdapterProvider(cartAdapterFamilyKey).notifier)
              .initiateCheckout(
                theme: context.isDarkMode ? 'dark' : 'light',
                cartItems: selectedProducts.isEmpty
                    ? widget.products
                    : selectedProducts.toList(),
              );
        },
        text: 'Checkout (\$${total.toStringAsFixed(2)})',
        textStyle:
            TextStyles.buttonTextHeadingSemiBold.copyWith(fontSize: 16).white,
      ).loading(cartAdapter is InitiatingCheckout),
    );
  }
}
