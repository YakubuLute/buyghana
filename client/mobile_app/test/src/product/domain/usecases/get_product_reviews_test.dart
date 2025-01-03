import 'package:dartz/dartz.dart';
import 'package:ecomly/src/product/domain/entities/review.dart';
import 'package:ecomly/src/product/domain/usecases/get_product_reviews.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'product_repo.mock.dart';

void main() {
  late MockProductRepo repo;
  late GetProductReviews usecase;

  const tProductId = 'Test String';

  const tPage = 1;
  final tResult = <Review>[Review.empty()];

  setUp(() {
    repo = MockProductRepo();
    usecase = GetProductReviews(repo);
    registerFallbackValue(tProductId);
    registerFallbackValue(tPage);
  });

  test(
    'should return [List<Review>] from the repo',
    () async {
      when(
        () => repo.getProductReviews(
          productId: any(named: "productId"),
          page: any(named: "page"),
        ),
      ).thenAnswer(
        (_) async => Right(tResult),
      );

      final result = await usecase(
        const GetProductReviewsParams(
          productId: tProductId,
          page: tPage,
        ),
      );
      expect(result, equals(Right<dynamic, List<Review>>(tResult)));
      verify(
        () => repo.getProductReviews(
          productId: any(named: "productId"),
          page: any(named: "page"),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
