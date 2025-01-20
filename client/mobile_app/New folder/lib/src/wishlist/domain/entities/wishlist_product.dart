import 'package:equatable/equatable.dart';

class WishlistProduct extends Equatable {
  const WishlistProduct({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productExists,
    required this.productOutOfStock,
  });

  const WishlistProduct.empty()
      : productId = "Test String",
        productName = "Test String",
        productImage = "Test String",
        productPrice = 1.0,
        productExists = true,
        productOutOfStock = true;

  final String productId;
  final String productName;
  final String productImage;
  final double productPrice;
  final bool productExists;
  final bool productOutOfStock;

  @override
  List<dynamic> get props => [
        productId,
        productName,
        productImage,
        productPrice,
        productExists,
        productOutOfStock,
      ];
}
