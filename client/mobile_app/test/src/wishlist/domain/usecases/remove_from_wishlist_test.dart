import 'package:dartz/dartz.dart';
import 'package:ecomly/src/wishlist/domain/usecases/remove_from_wishlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'wishlist_repo.mock.dart';

void main() {
  late MockWishlistRepo repo;
  late RemoveFromWishlist usecase;

  const tUserId = 'Test String';

  const tProductId = 'Test String';

  setUp(() {
    repo = MockWishlistRepo();
    usecase = RemoveFromWishlist(repo);
    registerFallbackValue(tUserId);
    registerFallbackValue(tProductId);
  });

  test(
    'should call the [WishlistRepo.removeFromWishlist]',
    () async {
      when(
        () => repo.removeFromWishlist(
          userId: any(named: "userId"),
          productId: any(named: "productId"),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const RemoveFromWishlistParams(
          userId: tUserId,
          productId: tProductId,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.removeFromWishlist(
          userId: any(named: "userId"),
          productId: any(named: "productId"),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
