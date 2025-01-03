import 'dart:convert';

import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/product/data/models/review_model.dart';
import 'package:ecomly/src/product/domain/entities/review.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tReviewModel = ReviewModel.empty(
    DateTime.parse('2023-12-04T20:45:40.426'),
  );

  group('ReviewModel', () {
    test('should be a subclass of [Review] entity', () async {
      expect(tReviewModel, isA<Review>());
    });

    group('fromMap', () {
      test('should return a valid [ReviewModel] when the JSON is not null',
          () async {
        final map = jsonDecode(fixture('review.json')) as DataMap;
        final result = ReviewModel.fromMap(map);
        expect(result, tReviewModel);
      });
    });

    group('fromJson', () {
      test('should return a valid [ReviewModel] when the JSON is not null',
          () async {
        final json = fixture('review.json');
        final result = ReviewModel.fromJson(json);
        expect(result, tReviewModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final map = jsonDecode(fixture('review.json')) as DataMap;
        final result = tReviewModel.toMap();
        expect(result, map);
      });
    });

    group('toJson', () {
      test('should return a JSON string containing the proper data', () async {
        final json = jsonEncode(jsonDecode(fixture('review.json')));
        final result = tReviewModel.toJson();
        expect(result, json);
      });
    });

    group('copyWith', () {
      test('should return a new [ReviewModel] with the same values', () async {
        final result = tReviewModel.copyWith(id: '');
        expect(result.id, equals(''));
      });
    });
  });
}
