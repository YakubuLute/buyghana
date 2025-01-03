import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/order/domain/entities/order.dart';

abstract class OrderRepo {
  ResultFuture<Order> getOrder(String orderId);
  ResultFuture<DataMap> getUserOrders(String userId);
}
