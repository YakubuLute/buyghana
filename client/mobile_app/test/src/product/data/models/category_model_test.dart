import 'dart:convert';

import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/product/data/models/category_model.dart';
import 'package:ecomly/src/product/domain/entities/category.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tProductCategoryModel = ProductCategoryModel.empty();

  group('ProductCategoryModel', () {
    test('should be a subclass of [ProductCategory] entity', () async {
      expect(tProductCategoryModel, isA<ProductCategory>());
    });

    group('fromMap', () {
      test(
          'should return a valid [ProductCategoryModel] when the JSON '
          'is not null', () async {
        final map = jsonDecode(fixture('product_category.json')) as DataMap;
        final result = ProductCategoryModel.fromMap(map);
        expect(result, tProductCategoryModel);
      });
    });

    group('fromJson', () {
      test(
          'should return a valid [ProductCategoryModel] when the JSON '
          'is not null', () async {
        final json = fixture('product_category.json');
        final result = ProductCategoryModel.fromJson(json);
        expect(result, tProductCategoryModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final result = tProductCategoryModel.toMap();
        expect(result, {
          'id': 'Test String',
          'name': null,
          'colour': null,
          'image': null,
        });
      });
    });

    group('toJson', () {
      test('should return a JSON string containing the proper data', () async {
        final result = tProductCategoryModel.toJson();
        expect(
          result,
          jsonEncode({
            'id': 'Test String',
            'name': null,
            'colour': null,
            'image': null,
          }),
        );
      });
    });

    group('copyWith', () {
      test('should return a new [ProductCategoryModel] with the same values',
          () async {
        final result = tProductCategoryModel.copyWith(id: '');
        expect(result.id, equals(''));
      });
    });
  });
}
