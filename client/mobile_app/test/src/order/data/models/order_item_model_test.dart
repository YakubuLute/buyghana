import 'dart:convert';

import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/order/data/models/order_item_model.dart';
import 'package:ecomly/src/order/domain/entities/order_item.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tOrderItemModel = OrderItemModel.empty();

  group('OrderItemModel', () {
    test('should be a subclass of [OrderItem] entity', () async {
      expect(tOrderItemModel, isA<OrderItem>());
    });

    group('fromMap', () {
      test('should return a valid [OrderItemModel] when the JSON is not null',
          () async {
        final map = jsonDecode(fixture('order_item.json')) as DataMap;
        final result = OrderItemModel.fromMap(map);
        expect(result, tOrderItemModel);
      });
    });

    group('fromJson', () {
      test('should return a valid [OrderItemModel] when the JSON is not null',
          () async {
        final json = fixture('order_item.json');
        final result = OrderItemModel.fromJson(json);
        expect(result, tOrderItemModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final map = jsonDecode(fixture('order_item.json')) as DataMap;
        final result = tOrderItemModel.toMap();
        expect(result, map);
      });
    });

    group('toJson', () {
      test('should return a JSON string containing the proper data', () async {
        final json = jsonEncode(jsonDecode(fixture('order_item.json')));
        final result = tOrderItemModel.toJson();
        expect(result, json);
      });
    });

    group('copyWith', () {
      test('should return a new [OrderItemModel] with the same values',
          () async {
        final result = tOrderItemModel.copyWith(productId: '');
        expect(result.productId, equals(''));
      });
    });
  });
}
