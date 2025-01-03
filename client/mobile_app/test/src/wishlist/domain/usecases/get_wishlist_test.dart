import 'package:dartz/dartz.dart';
import 'package:ecomly/src/wishlist/domain/entities/wishlist_product.dart';
import 'package:ecomly/src/wishlist/domain/usecases/get_wishlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'wishlist_repo.mock.dart';

void main() {
  late MockWishlistRepo repo;
  late GetWishlist usecase;

  const tUserId = 'Test String';
  const tResult = <WishlistProduct>[WishlistProduct.empty()];

  setUp(() {
    repo = MockWishlistRepo();
    usecase = GetWishlist(repo);
    registerFallbackValue(tUserId);
  });

  test(
    'should return [List<WishlistProduct>] from the repo',
    () async {
      when(() => repo.getWishlist(any())).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(tUserId);
      expect(
        result,
        equals(const Right<dynamic, List<WishlistProduct>>(tResult)),
      );
      verify(() => repo.getWishlist(any())).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
