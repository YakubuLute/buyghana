import 'package:ecomly/core/utils/enums/order_status_enum.dart';
import 'package:ecomly/src/order/domain/entities/order_item.dart';
import 'package:ecomly/src/user/domain/entities/address.dart';
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  const Order({
    required this.id,
    required this.orderItems,
    required this.address,
    required this.phone,
    required this.status,
    required this.statusHistory,
    required this.totalPrice,
    required this.dateOrdered,
    this.paymentId,
  });

  Order.empty()
      : id = "Test String",
        orderItems = [],
        address = const Address.empty(),
        phone = "Test String",
        paymentId = "Test String",
        status = OrderStatus.pending,
        statusHistory = [],
        totalPrice = 1,
        dateOrdered = DateTime.now();

  final String id;
  final List<OrderItem> orderItems;
  final Address address;
  final String phone;
  final String? paymentId;
  final OrderStatus status;
  final List<OrderStatus> statusHistory;
  final double totalPrice;
  final DateTime dateOrdered;

  @override
  List<dynamic> get props => [
        id,
        address,
        orderItems.length,
        statusHistory.length,
        phone,
        paymentId,
        status,
        totalPrice,
        dateOrdered,
      ];
}
