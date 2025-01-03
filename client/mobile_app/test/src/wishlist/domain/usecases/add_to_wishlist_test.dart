import 'package:dartz/dartz.dart';
import 'package:ecomly/src/wishlist/domain/usecases/add_to_wishlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'wishlist_repo.mock.dart';

void main() {
  late MockWishlistRepo repo;
  late AddToWishlist usecase;

  const tUserId = 'Test String';

  const tProductId = 'Test String';

  setUp(() {
    repo = MockWishlistRepo();
    usecase = AddToWishlist(repo);
    registerFallbackValue(tUserId);
    registerFallbackValue(tProductId);
  });

  test(
    'should call the [WishlistRepo.addToWishlist]',
    () async {
      when(
        () => repo.addToWishlist(
          userId: any(named: "userId"),
          productId: any(named: "productId"),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const AddToWishlistParams(
          userId: tUserId,
          productId: tProductId,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.addToWishlist(
          userId: any(named: "userId"),
          productId: any(named: "productId"),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
