import 'package:ecomly/core/common/singletons/cache.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/core/utils/global_keys.dart';
import 'package:ecomly/src/cart/presentation/app/cart_riverpod_adapter/cart_provider.dart';
import 'package:ecomly/src/cart/presentation/views/checkout_successful_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutView extends ConsumerStatefulWidget {
  const CheckoutView({required this.sessionUrl, super.key});

  final String sessionUrl;

  static const path = '/checkout';

  @override
  ConsumerState<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends ConsumerState<CheckoutView> {
  late WebViewController controller;
  final loadingNotifier = ValueNotifier(false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colours.lightThemeTintStockColour)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            CoreUtils.postFrameCall(() {
              loadingNotifier.value = true;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            CoreUtils.postFrameCall(() {
              loadingNotifier.value = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint(error.errorType.toString());
            CoreUtils.showSnackBar(
              context,
              message: '${error.errorCode} Error: ${error.description}',
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url
                .startsWith('https://dbestech.biz/payment-success')) {
              ref
                  .read(
                    cartAdapterProvider(GlobalKeys.cartScreenAdapterFamilyKey)
                        .notifier,
                  )
                  .getCart(Cache.instance.userId!);
              ref
                  .read(cartAdapterProvider(GlobalKeys.cartCountFamilyKey)
                      .notifier)
                  .getCartCount(
                    Cache.instance.userId!,
                  );
              context.pushReplacement(CheckoutSuccessfulView.path);
              return NavigationDecision.prevent;
            } else if (request.url.startsWith('https://dbestech.biz/cart')) {
              context.pop();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.sessionUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: loadingNotifier,
          builder: (context, isLoading, __) {
            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colours.lightThemePrimaryColour,
                ),
              );
            }
            return WebViewWidget(controller: controller);
          },
        ),
      ),
    );
  }
}
