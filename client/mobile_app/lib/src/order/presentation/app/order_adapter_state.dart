part of 'order_adapter_provider.dart';

class OrderAdapterState extends Equatable {
  const OrderAdapterState();

  @override
  List<Object?> get props => [];
}

class OrderAdapterInitial extends OrderAdapterState {
  const OrderAdapterInitial();
}

class FetchingOrder extends OrderAdapterState {
  const FetchingOrder();
}

class FetchingOrders extends OrderAdapterState {
  const FetchingOrders();
}

class OrderFetched extends OrderAdapterState {
  const OrderFetched(this.order);

  final Order order;

  @override
  List<Object?> get props => [order];
}

class OrdersFetched extends OrderAdapterState {
  const OrdersFetched(this.orders);

  final DataMap orders;

  @override
  List<Object?> get props => [
        orders['total'],
        ...orders['active'] as List<Order>,
        ...orders['completed'] as List<Order>,
        ...orders['cancelled'] as List<Order>
      ];
}

class OrderError extends OrderAdapterState {
  const OrderError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
