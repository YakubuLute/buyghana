import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentProfileView extends ConsumerStatefulWidget {
  const PaymentProfileView({required this.sessionUrl, super.key});

  final String sessionUrl;

  static const path = '/payment-profile';

  @override
  ConsumerState<PaymentProfileView> createState() => _PaymentProfileViewState();
}

class _PaymentProfileViewState extends ConsumerState<PaymentProfileView> {
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
            if (request.url.startsWith('https://dbestech.biz/ecomly')) {
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
