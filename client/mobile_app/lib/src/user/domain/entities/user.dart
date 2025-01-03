import 'package:ecomly/src/user/domain/entities/address.dart';
import 'package:ecomly/src/wishlist/domain/entities/wishlist_product.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
    required this.wishlist,
    this.address,
    this.phone,
  });

  const User.empty()
      : id = "Test String",
        name = "Test String",
        email = "Test String",
        isAdmin = true,
        wishlist = const [],
        address = null,
        phone = null;

  final String id;
  final String name;
  final String email;
  final bool isAdmin;
  final List<WishlistProduct> wishlist;
  final Address? address;
  final String? phone;

  @override
  List<dynamic> get props => [
        id,
        name,
        email,
        isAdmin,
        wishlist.length,
      ];
}
