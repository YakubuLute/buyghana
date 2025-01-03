import 'package:ecomly/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly/core/common/widgets/empty_data.dart';
import 'package:ecomly/core/res/media.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/order/presentation/app/order_adapter_provider.dart';
import 'package:ecomly/src/order/presentation/widgets/orders_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class OrdersView extends ConsumerStatefulWidget {
  const OrdersView({required this.userId, super.key});

  // this is better here than just using Cache.instance.userId, because when
  // testing, we can easily inject this here, instead of having to initialize
  // the cache
  final String userId;

  @override
  ConsumerState createState() => _OrdersViewState();
}

class _OrdersViewState extends ConsumerState<OrdersView> {
  final orderAdapterFamilyKey = GlobalKey();

  Future<void> getUserOrders() async {
    return ref
        .read(orderAdapterProvider(orderAdapterFamilyKey).notifier)
        .getUserOrders(widget.userId);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserOrders();
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
      onRefresh: getUserOrders,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          bottom: const AppBarBottom(),
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              if (orderAdapter is FetchingOrders) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colours.lightThemePrimaryColour,
                  ),
                );
              } else if (orderAdapter is OrdersFetched) {
                if (orderAdapter.orders['total'] as int < 1) {
                  return const EmptyData(
                    'No Orders\nComplete your first '
                    'checkout to track your orders here',
                  );
                }
                return OrdersBody(orderAdapter.orders);
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
