import 'dart:convert';

import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/product/domain/entities/category.dart';

class ProductCategoryModel extends ProductCategory {
  const ProductCategoryModel({
    required super.id,
    super.name,
    super.colour,
    super.image,
  });

  const ProductCategoryModel.empty() : this(id: "Test String");

  factory ProductCategoryModel.fromJson(String source) =>
      ProductCategoryModel.fromMap(jsonDecode(source) as DataMap);

  ProductCategoryModel.fromMap(DataMap map)
      : this(
            id: map['id'] as String,
            name: map['name'] as String?,
            colour: map['colour'] as String?,
            image: map['image'] as String?);

  ProductCategoryModel copyWith({
    String? id,
    String? name,
    String? colour,
    String? image,
  }) {
    return ProductCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      colour: colour ?? this.colour,
      image: image ?? this.image,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'colour': colour,
      'image': image,
    };
  }

  String toJson() => jsonEncode(toMap());
}
