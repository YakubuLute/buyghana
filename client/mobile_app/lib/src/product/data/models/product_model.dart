import 'dart:convert';
import 'dart:ui';

import 'package:ecomly/core/extensions/colour_extensions.dart';
import 'package:ecomly/core/extensions/string_extensions.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/product/data/models/category_model.dart';
import 'package:ecomly/src/product/domain/entities/category.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.rating,
    required super.colours,
    required super.image,
    required super.images,
    required super.reviewIds,
    required super.numberOfReviews,
    required super.sizes,
    required super.category,
    super.genderAgeCategory,
    required super.countInStock,
  });

  const ProductModel.empty()
      : this(
          id: "Test String",
          name: "Test String",
          description: "Test String",
          price: 1,
          rating: 1,
          colours: const [],
          image: "Test String",
          images: const [],
          reviewIds: const [],
          numberOfReviews: 1,
          sizes: const [],
          category: const ProductCategoryModel.empty(),
          genderAgeCategory: "Test String",
          countInStock: 1,
        );

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(jsonDecode(source) as DataMap);

  factory ProductModel.fromMap(DataMap map) {
    final colours = map['colours'] as List<dynamic>?;
    final images = map['images'] as List<dynamic>?;
    final reviewIds = map['reviewIds'] as List<dynamic>?;
    final sizes = map['sizes'] as List<dynamic>?;
    final category = map['category'];
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      rating: (map['rating'] as num).toDouble(),
      colours: colours == null
          ? []
          : List<String>.from(colours).map((hex) => hex.colour).toList(),
      image: map['image'] as String,
      images: images == null ? [] : List<String>.from(images),
      reviewIds: reviewIds == null ? [] : List<String>.from(reviewIds),
      numberOfReviews: (map['numberOfReviews'] as num).toInt(),
      sizes: sizes == null ? [] : List<String>.from(sizes),
      category: category is String
          ? ProductCategoryModel(id: category)
          : ProductCategoryModel.fromMap(category as DataMap),
      genderAgeCategory: map['genderAgeCategory'] as String?,
      countInStock: (map['countInStock'] as num).toInt(),
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? rating,
    List<Color>? colours,
    String? image,
    List<String>? images,
    List<String>? reviewIds,
    int? numberOfReviews,
    List<String>? sizes,
    ProductCategory? category,
    String? genderAgeCategory,
    int? countInStock,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      colours: colours ?? this.colours,
      image: image ?? this.image,
      images: images ?? this.images,
      reviewIds: reviewIds ?? this.reviewIds,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
      sizes: sizes ?? this.sizes,
      category: category ?? this.category,
      genderAgeCategory: genderAgeCategory ?? this.genderAgeCategory,
      countInStock: countInStock ?? this.countInStock,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'rating': rating,
      'colours': colours.map((colour) => colour.hex).toList(),
      'image': image,
      'images': images,
      'reviewIds': reviewIds,
      'numberOfReviews': numberOfReviews,
      'sizes': sizes,
      'category': category.id,
      'genderAgeCategory': genderAgeCategory,
      'countInStock': countInStock,
    };
  }

  String toJson() => jsonEncode(toMap());
}
