import 'dart:convert';
import 'dart:ui';

import 'package:ecomly/core/extensions/colour_extensions.dart';
import 'package:ecomly/core/extensions/string_extensions.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/order/domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.productImage,
    required super.productPrice,
    required super.quantity,
    super.selectedSize,
    super.selectedColour,
  });

  const OrderItemModel.empty()
      : this(
          id: "Test String",
          productId: "Test String",
          productName: "Test String",
          productImage: "Test String",
          productPrice: 1.0,
          quantity: 1,
          selectedSize: "Test String",
          selectedColour: null,
        );

  factory OrderItemModel.fromJson(String source) =>
      OrderItemModel.fromMap(jsonDecode(source) as DataMap);

  OrderItemModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String? ?? map['_id'] as String,
          productId: map['product'] as String? ?? '',
          productName: map['productName'] as String,
          productImage: map['productImage'] as String,
          productPrice: (map['productPrice'] as num?)?.toDouble() ?? 0.0,
          quantity: (map['quantity'] as num?)?.toInt() ?? 0,
          selectedSize: map['selectedSize'] as String?,
          selectedColour: (map['selectedColour'] as String?)?.colour,
        );

  OrderItemModel copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImage,
    double? productPrice,
    int? quantity,
    String? selectedSize,
    Color? selectedColour,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColour: selectedColour ?? this.selectedColour,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'product': productId,
      'productName': productName,
      'productImage': productImage,
      'productPrice': productPrice,
      'quantity': quantity,
      if (selectedSize != null) 'selectedSize': selectedSize,
      if (selectedColour != null) 'selectedColour': selectedColour!.hex,
    };
  }

  String toJson() => jsonEncode(toMap());
}
