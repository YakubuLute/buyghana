import 'package:dartz/dartz.dart';
import 'package:ecomly/src/product/domain/usecases/leave_review.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'product_repo.mock.dart';

void main() {
  late MockProductRepo repo;
  late LeaveReview usecase;

  const tProductId = 'Test String';

  const tUserId = 'Test String';

  const tComment = 'Test String';

  const tRating = 1.0;

  setUp(() {
    repo = MockProductRepo();
    usecase = LeaveReview(repo);
    registerFallbackValue(tProductId);
    registerFallbackValue(tUserId);
    registerFallbackValue(tComment);
    registerFallbackValue(tRating);
  });

  test(
    'should call the [ProductRepo.leaveReview]',
    () async {
      when(
        () => repo.leaveReview(
          productId: any(named: "productId"),
          userId: any(named: "userId"),
          comment: any(named: "comment"),
          rating: any(named: "rating"),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const LeaveReviewParams(
          productId: tProductId,
          userId: tUserId,
          comment: tComment,
          rating: tRating,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.leaveReview(
          productId: any(named: "productId"),
          userId: any(named: "userId"),
          comment: any(named: "comment"),
          rating: any(named: "rating"),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
