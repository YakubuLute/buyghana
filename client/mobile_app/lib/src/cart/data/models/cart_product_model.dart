import 'dart:convert';
import 'dart:ui';

import 'package:ecomly/core/extensions/colour_extensions.dart';
import 'package:ecomly/core/extensions/string_extensions.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/cart/domain/entities/cart_product.dart';

class CartProductModel extends CartProduct {
  const CartProductModel({
    required super.id,
    required super.productId,
    required super.quantity,
    required super.productName,
    required super.productImage,
    required super.productPrice,
    required super.productExists,
    required super.productOutOfStock,
    super.selectedSize,
    super.selectedColour,
  });

  const CartProductModel.empty()
      : this(
          id: "Test String",
          productId: "Test String",
          quantity: 1,
          productName: "Test String",
          productImage: "Test String",
          productPrice: 1,
          selectedSize: null,
          selectedColour: null,
          productExists: true,
          productOutOfStock: true,
        );

  factory CartProductModel.fromJson(String source) =>
      CartProductModel.fromMap(jsonDecode(source) as DataMap);

  CartProductModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String? ?? map['_id'] as String,
          productId: map['product'] as String,
          quantity: (map['quantity'] as num).toInt(),
          productName: map['productName'] as String,
          productImage: map['productImage'] as String,
          productPrice: (map['productPrice'] as num).toDouble(),
          selectedSize: map['selectedSize'] as String?,
          selectedColour: (map['selectedColour'] as String?)?.colour,
          productExists: map['productExists'] as bool? ?? true,
          productOutOfStock: map['productOutOfStock'] as bool? ?? false,
        );

  CartProductModel copyWith({
    String? id,
    String? productId,
    int? quantity,
    String? productName,
    String? productImage,
    double? productPrice,
    String? selectedSize,
    Color? selectedColour,
    bool? productExists,
    bool? productOutOfStock,
  }) {
    return CartProductModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      productPrice: productPrice ?? this.productPrice,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColour: selectedColour ?? this.selectedColour,
      productExists: productExists ?? this.productExists,
      productOutOfStock: productOutOfStock ?? this.productOutOfStock,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'product': productId,
      'quantity': quantity,
      'productName': productName,
      'productImage': productImage,
      'productPrice': productPrice,
      if (selectedSize != null) 'selectedSize': selectedSize,
      if (selectedColour != null) 'selectedColour': selectedColour!.hex,
    };
  }

  String toJson() => jsonEncode(toMap());
}
