import 'package:ecomly/core/services/injection_container.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/order/domain/entities/order.dart';
import 'package:ecomly/src/order/domain/usecases/get_order.dart';
import 'package:ecomly/src/order/domain/usecases/get_user_orders.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_adapter_provider.g.dart';
part 'order_adapter_state.dart';

@riverpod
class OrderAdapter extends _$OrderAdapter {
  @override
  OrderAdapterState build([GlobalKey? familyKey]) {
    _getOrder = sl<GetOrder>();
    _getUserOrders = sl<GetUserOrders>();
    return const OrderAdapterInitial();
  }

  late final GetOrder _getOrder;
  late final GetUserOrders _getUserOrders;

  Future<void> getOrder(String orderId) async {
    state = const FetchingOrder();

    final result = await _getOrder(orderId);

    result.fold(
      (failure) => state = OrderError(failure.errorMessage),
      (order) => state = OrderFetched(order),
    );
  }

  Future<void> getUserOrders(String userId) async {
    state = const FetchingOrders();

    final result = await _getUserOrders(userId);

    result.fold(
      (failure) => state = OrderError(failure.errorMessage),
      (orders) => state = OrdersFetched(orders),
    );
  }
}
