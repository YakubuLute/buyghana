import 'package:ecomly/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly/core/res/media.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/order/presentation/app/order_adapter_provider.dart';
import 'package:ecomly/src/order/presentation/widgets/order_details_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class OrderDetailsView extends ConsumerStatefulWidget {
  const OrderDetailsView({required this.orderId, super.key});

  final String orderId;

  @override
  ConsumerState createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends ConsumerState<OrderDetailsView> {
  final orderAdapterFamilyKey = GlobalKey();

  Future<void> getOrder() async {
    return ref
        .read(orderAdapterProvider(orderAdapterFamilyKey).notifier)
        .getOrder(widget.orderId);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderAdapter = ref.watch(
      orderAdapterProvider(orderAdapterFamilyKey),
    );
    ref.listen(orderAdapterProvider(orderAdapterFamilyKey), (previous, next) {
      if (next is OrderError) {
        CoreUtils.showSnackBar(
          context,
          message: '${next.message}\nPULL TO REFRESH',
        );
      }
    });
    return RefreshIndicator.adaptive(
      onRefresh: getOrder,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order Details'),
          bottom: const AppBarBottom(),
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              if (orderAdapter is FetchingOrder) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colours.lightThemePrimaryColour,
                  ),
                );
              } else if (orderAdapter is OrderFetched) {
                return OrderDetailsBody(orderAdapter.order);
              } else if (orderAdapter is OrderError) {
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
