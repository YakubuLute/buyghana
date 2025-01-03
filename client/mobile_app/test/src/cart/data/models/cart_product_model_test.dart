import 'dart:convert';

import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/cart/data/models/cart_product_model.dart';
import 'package:ecomly/src/cart/domain/entities/cart_product.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tCartProductModel = CartProductModel.empty();

  group('CartProductModel', () {
    test('should be a subclass of [CartProduct] entity', () async {
      expect(tCartProductModel, isA<CartProduct>());
    });

    group('fromMap', () {
      test('should return a valid [CartProductModel] when the JSON is not null',
          () async {
        final map = jsonDecode(fixture('cart_product.json')) as DataMap;
        final result = CartProductModel.fromMap(map);
        expect(result, tCartProductModel);
      });
    });

    group('fromJson', () {
      test('should return a valid [CartProductModel] when the JSON is not null',
          () async {
        final json = fixture('cart_product.json');
        final result = CartProductModel.fromJson(json);
        expect(result, tCartProductModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final map = jsonDecode(fixture('cart_product.json')) as DataMap;
        final result = tCartProductModel.toMap();
        expect(
          result,
          map
            ..remove('productExists')
            ..remove('productOutOfStock'),
        );
      });
    });

    group('toJson', () {
      test('should return a JSON string containing the proper data', () async {
        final json = jsonEncode(
          (jsonDecode(fixture('cart_product.json')) as DataMap)
            ..remove('productExists')
            ..remove('productOutOfStock'),
        );
        final result = tCartProductModel.toJson();
        expect(result, json);
      });
    });

    group('copyWith', () {
      test('should return a new [CartProductModel] with the same values',
          () async {
        final result = tCartProductModel.copyWith(productId: '');
        expect(result.productId, equals(''));
      });
    });
  });
}
