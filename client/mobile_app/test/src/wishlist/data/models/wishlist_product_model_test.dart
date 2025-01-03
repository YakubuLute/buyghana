import 'dart:convert';

import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/wishlist/data/models/wishlist_product_model.dart';
import 'package:ecomly/src/wishlist/domain/entities/wishlist_product.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tWishlistProductModel = WishlistProductModel.empty();

  group('WishlistProductModel', () {
    test('should be a subclass of [WishlistProduct] entity', () async {
      expect(tWishlistProductModel, isA<WishlistProduct>());
    });

    group('fromMap', () {
      test(
          'should return a valid [WishlistProductModel] when the JSON is not null',
          () async {
        final map = jsonDecode(fixture('wishlist_product.json')) as DataMap;
        final result = WishlistProductModel.fromMap(map);
        expect(result, tWishlistProductModel);
      });
    });

    group('fromJson', () {
      test(
          'should return a valid [WishlistProductModel] when the JSON is not null',
          () async {
        final json = fixture('wishlist_product.json');
        final result = WishlistProductModel.fromJson(json);
        expect(result, tWishlistProductModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final map = jsonDecode(fixture('wishlist_product.json')) as DataMap;
        final result = tWishlistProductModel.toMap();
        expect(result, map);
      });
    });

    group('toJson', () {
      test('should return a JSON string containing the proper data', () async {
        final json = jsonEncode(jsonDecode(fixture('wishlist_product.json')));
        final result = tWishlistProductModel.toJson();
        expect(result, json);
      });
    });

    group('copyWith', () {
      test('should return a new [WishlistProductModel] with the same values',
          () async {
        final result = tWishlistProductModel.copyWith(productId: '');
        expect(result.productId, equals(''));
      });
    });
  });
}
