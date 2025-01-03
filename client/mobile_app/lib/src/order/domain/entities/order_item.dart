import 'dart:ui';

import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  const OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.quantity,
    this.selectedSize,
    this.selectedColour,
  });

  const OrderItem.empty()
      : id = "Test String",
        productId = "Test String",
        productName = "Test String",
        productImage = "Test String",
        productPrice = 1.0,
        quantity = 1,
        selectedSize = "Test String",
        selectedColour = null;

  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double productPrice;
  final int quantity;
  final String? selectedSize;
  final Color? selectedColour;

  @override
  List<dynamic> get props => [
        id,
        productId,
        productName,
        productImage,
        productPrice,
        quantity,
        selectedSize,
        selectedColour,
      ];
}
