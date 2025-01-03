import 'dart:convert';

import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/user/data/models/user_model.dart';
import 'package:ecomly/src/user/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUserModel = UserModel.empty();

  group('UserModel', () {
    test('should be a subclass of [User] entity', () async {
      expect(tUserModel, isA<User>());
    });

    group('fromMap', () {
      test('should return a valid [UserModel] when the JSON is not null',
          () async {
        final map = jsonDecode(fixture('user.json')) as DataMap;
        final result = UserModel.fromMap(map);
        expect(result, tUserModel);
      });
    });

    group('fromJson', () {
      test('should return a valid [UserModel] when the JSON is not null',
          () async {
        final json = fixture('user.json');
        final result = UserModel.fromJson(json);
        expect(result, tUserModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final map = jsonDecode(fixture('user.json')) as DataMap;
        final result = tUserModel.toMap();
        expect(result, map);
      });
    });

    group('toJson', () {
      test('should return a JSON string containing the proper data', () async {
        final json = jsonEncode(jsonDecode(fixture('user.json')));
        final result = tUserModel.toJson();
        expect(result, json);
      });
    });

    group('copyWith', () {
      test('should return a new [UserModel] with the same values', () async {
        final result = tUserModel.copyWith(id: '');
        expect(result.id, equals(''));
      });
    });
  });
}
