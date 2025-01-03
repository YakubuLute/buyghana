import 'dart:convert';

import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/product/data/models/product_model.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tProductModel = ProductModel.empty();

  group('ProductModel', () {
    test('should be a subclass of [Product] entity', () async {
      expect(tProductModel, isA<Product>());
    });

    group('fromMap', () {
      test('should return a valid [ProductModel] when the JSON is not null',
          () async {
        final map = jsonDecode(fixture('product.json')) as DataMap;
        final result = ProductModel.fromMap(map);
        expect(result, tProductModel);
      });
    });

    group('fromJson', () {
      test('should return a valid [ProductModel] when the JSON is not null',
          () async {
        final json = fixture('product.json');
        final result = ProductModel.fromJson(json);
        expect(result, tProductModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final map = jsonDecode(fixture('product.json')) as DataMap;
        final result = tProductModel.toMap();
        expect(result, map);
      });
    });

    group('toJson', () {
      test('should return a JSON string containing the proper data', () async {
        final json = jsonEncode(jsonDecode(fixture('product.json')));
        final result = tProductModel.toJson();
        expect(result, json);
      });
    });

    group('copyWith', () {
      test('should return a new [ProductModel] with the same values', () async {
        final result = tProductModel.copyWith(id: '');
        expect(result.id, equals(''));
      });
    });
  });
}
