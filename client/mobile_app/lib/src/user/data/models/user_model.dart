
import 'dart:convert';

import 'package:buyghana/core/utils/typedefs.dart';
import 'package:buyghana/src/user/data/models/address_model.dart';
import 'package:buyghana/src/user/domain/entities/address.dart';
import 'package:buyghana/src/user/domain/entities/user.dart';
import 'package:buyghana/src/wishlist/data/models/wishlist_product_model.dart';
import 'package:buyghana/src/wishlist/domain/entities/wishlist_product.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.isAdmin,
    required super.wishlist,
    super.address,
    super.phone,
  });

  UserModel.empty()
      : this(
          id: "Test String",
          name: "Test String",
          email: "Test String",
          isAdmin: true,
          wishlist: [],
          address: null,
          phone: null,
        );

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  factory UserModel.fromMap(DataMap map) {
    // Safely handle address if present
    final address = map.containsKey('address') && map['address'] != null
        ? AddressModel.fromMap(map['address'] as DataMap)
        : null;

    // Safely handle wishlist, defaulting to empty list if not present
    final wishlistData = map['wishlist'] as List<dynamic>? ?? [];
    final wishlist = wishlistData
        .map((item) => WishlistProductModel.fromMap(item as DataMap))
        .toList();

    return UserModel(
      id: map['id'] as String? ?? map['_id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      isAdmin: map['isAdmin'] as bool? ?? false,
      wishlist: wishlist,
      address: address,
      phone: map['phone'] as String?,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? isAdmin,
    List<WishlistProduct>? wishlist,
    Address? address,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
      wishlist: wishlist ?? this.wishlist,
      address: address ?? this.address,
      phone: phone ?? this.phone,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
      'wishlist': wishlist
          .map(
            (product) => (product as WishlistProductModel).toMap(),
          )
          .toList(),
      if (address != null) 'address': (address as AddressModel).toMap(),
      if (phone != null) 'phone': phone,
    };
  }

  String toJson() => jsonEncode(toMap());
}
