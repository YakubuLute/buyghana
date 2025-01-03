import 'dart:convert';

import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/user/data/models/address_model.dart';
import 'package:ecomly/src/user/domain/entities/address.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tAddressModel = AddressModel.empty();

  group('AddressModel', () {
    test('should be a subclass of [Address] entity', () async {
      expect(tAddressModel, isA<Address>());
    });

    group('fromMap', () {
      test('should return a valid [AddressModel] when the JSON is not null',
          () async {
        final map = jsonDecode(fixture('address.json')) as DataMap;
        final result = AddressModel.fromMap(map);
        expect(result, tAddressModel);
      });
    });

    group('fromJson', () {
      test('should return a valid [AddressModel] when the JSON is not null',
          () async {
        final json = fixture('address.json');
        final result = AddressModel.fromJson(json);
        expect(result, tAddressModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final map = jsonDecode(fixture('address.json')) as DataMap;
        final result = tAddressModel.toMap();
        expect(result, map);
      });
    });

    group('toJson', () {
      test('should return a JSON string containing the proper data', () async {
        final json = jsonEncode(jsonDecode(fixture('address.json')));
        final result = tAddressModel.toJson();
        expect(result, json);
      });
    });

    group('copyWith', () {
      test('should return a new [AddressModel] with the same values', () async {
        final result = tAddressModel.copyWith(street: '');
        expect(result.street, equals(''));
      });
    });
  });
}
