import 'dart:ui';

import 'package:equatable/equatable.dart';

class CartProduct extends Equatable {
  const CartProduct({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    this.selectedSize,
    this.selectedColour,
    required this.productExists,
    required this.productOutOfStock,
  });

  const CartProduct.empty()
      : id = "Test String",
        productId = "Test String",
        quantity = 1,
        productName = "Test String",
        productImage = "Test String",
        productPrice = 1,
        selectedSize = null,
        selectedColour = null,
        productExists = true,
        productOutOfStock = true;

  final String id;
  final String productId;
  final int quantity;
  final String productName;
  final String productImage;
  final double productPrice;
  final String? selectedSize;
  final Color? selectedColour;
  final bool productExists;
  final bool productOutOfStock;

  @override
  List<dynamic> get props => [
        id,
        productId,
        quantity,
        productName,
        productImage,
        productPrice,
        selectedSize,
        selectedColour,
        productExists,
        productOutOfStock,
      ];
}
