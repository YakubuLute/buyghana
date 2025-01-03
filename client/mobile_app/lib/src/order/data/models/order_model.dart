import 'dart:convert';

import 'package:ecomly/core/extensions/string_extensions.dart';
import 'package:ecomly/core/utils/enums/order_status_enum.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/order/data/models/order_item_model.dart';
import 'package:ecomly/src/order/domain/entities/order.dart';
import 'package:ecomly/src/order/domain/entities/order_item.dart';
import 'package:ecomly/src/user/data/models/address_model.dart';
import 'package:ecomly/src/user/domain/entities/address.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.orderItems,
    required super.address,
    required super.phone,
    super.paymentId,
    required super.status,
    required super.statusHistory,
    required super.totalPrice,
    required super.dateOrdered,
  });

  OrderModel.empty()
      : this(
          id: "Test String",
          orderItems: [],
          address: const Address.empty(),
          phone: "Test String",
          paymentId: "Test String",
          status: OrderStatus.pending,
          statusHistory: [],
          totalPrice: 1,
          dateOrdered: DateTime.now(),
        );

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(jsonDecode(source) as DataMap);

  factory OrderModel.fromMap(DataMap map) {
    final address = AddressModel.fromMap({
      if (map case {'shippingAddress1': String street}) 'street': street,
      if (map case {'city': String city}) 'city': city,
      if (map case {'postalCode': String postalCode}) 'postalCode': postalCode,
      if (map case {'country': String country}) 'country': country,
    });
    return OrderModel(
      id: map['id'] as String? ?? map['_id'] as String,
      orderItems: List<DataMap>.from(map['orderItems'] as List<dynamic>)
          .map(OrderItemModel.fromMap)
          .toList(),
      address: address,
      phone: map['phone'] as String? ?? '',
      paymentId: map['paymentId'] as String?,
      status: (map['status'] as String).toStatus,
      statusHistory: (map['statusHistory'] as List<dynamic>?)
              ?.cast<String>()
              .map((status) => status.toStatus)
              .toList() ??
          [],
      totalPrice: (map['totalPrice'] as num).toDouble(),
      dateOrdered: DateTime.parse(map['dateOrdered'] as String),
    );
  }

  OrderModel copyWith({
    String? id,
    List<OrderItem>? orderItems,
    Address? address,
    String? phone,
    String? Function()? paymentId,
    OrderStatus? status,
    List<OrderStatus>? statusHistory,
    double? totalPrice,
    DateTime? dateOrdered,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderItems: orderItems ?? this.orderItems,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      paymentId: paymentId != null ? paymentId.call() : this.paymentId,
      status: status ?? this.status,
      statusHistory: statusHistory ?? this.statusHistory,
      totalPrice: totalPrice ?? this.totalPrice,
      dateOrdered: dateOrdered ?? this.dateOrdered,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'orderItems': orderItems
          .map(
            (orderItem) => (orderItem as OrderItemModel).toMap(),
          )
          .toList(),
      if (!address.isEmpty) 'address': address,
      'phone': phone,
      'paymentId': paymentId,
      'status': status.value,
      'statusHistory': statusHistory.map((status) => status.value).toList(),
      'totalPrice': totalPrice,
      'dateOrdered': dateOrdered.toIso8601String(),
    };
  }

  String toJson() => jsonEncode(toMap());
}
