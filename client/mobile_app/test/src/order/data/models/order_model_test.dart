import 'dart:convert';

import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/order/data/models/order_item_model.dart';
import 'package:ecomly/src/order/data/models/order_model.dart';
import 'package:ecomly/src/order/domain/entities/order.dart';
import 'package:ecomly/src/user/data/models/address_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tOrderModel = OrderModel.empty().copyWith(
      address: const AddressModel(),
      orderItems: const [
        OrderItemModel(
          id: 'Test String',
          productId: '',
          productName: 'Test String',
          productImage: 'Test String',
          productPrice: 0.0,
          quantity: 0,
        ),
      ],
      phone: '',
      paymentId: () => null,
      dateOrdered: DateTime.parse('2023-12-04T20:45:40.426'));

  group('OrderModel', () {
    test('should be a subclass of [Order] entity', () async {
      expect(tOrderModel, isA<Order>());
    });

    group('fromMap', () {
      test('should return a valid [OrderModel] when the JSON is not null',
          () async {
        final map = jsonDecode(fixture('order.json')) as DataMap;
        final result = OrderModel.fromMap(map);
        expect(result, tOrderModel);
      });
    });

    group('fromJson', () {
      test('should return a valid [OrderModel] when the JSON is not null',
          () async {
        final json = fixture('order.json');
        final result = OrderModel.fromJson(json);
        expect(result, tOrderModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final map = {
          'id': 'Test String',
          'orderItems': [
            {
              'id': 'Test String',
              'product': '',
              'productName': 'Test String',
              'productImage': 'Test String',
              'productPrice': 0.0,
              'quantity': 0,
            }
          ],
          'phone': '',
          'paymentId': null,
          'status': 'pending',
          'statusHistory': [],
          'totalPrice': 1.0,
          'dateOrdered': '2023-12-04T20:45:40.426'
        };
        final result = tOrderModel.toMap();
        expect(result, map);
      });
    });

    group('toJson', () {
      test('should return a JSON string containing the proper data', () async {
        final json = jsonEncode({
          'id': 'Test String',
          'orderItems': [
            {
              'id': 'Test String',
              'product': '',
              'productName': 'Test String',
              'productImage': 'Test String',
              'productPrice': 0.0,
              'quantity': 0,
            }
          ],
          'phone': '',
          'paymentId': null,
          'status': 'pending',
          'statusHistory': [],
          'totalPrice': 1.0,
          'dateOrdered': '2023-12-04T20:45:40.426'
        });
        final result = tOrderModel.toJson();
        expect(result, json);
      });
    });

    group('copyWith', () {
      test('should return a new [OrderModel] with the same values', () async {
        final result = tOrderModel.copyWith(id: 'New Id');
        expect(result.id, equals('New Id'));
      });
    });
  });
}
