import 'package:dartz/dartz.dart';
import 'package:ecomly/src/cart/domain/entities/cart_product.dart';
import 'package:ecomly/src/cart/domain/usecases/get_cart_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'cart_repo.mock.dart';

void main() {
  late MockCartRepo repo;
  late GetCartProduct usecase;

  const tUserId = 'Test String';

  const tCartProductId = 'Test String';

  const tResult = CartProduct.empty();

  setUp(() {
    repo = MockCartRepo();
    usecase = GetCartProduct(repo);
    registerFallbackValue(tUserId);
    registerFallbackValue(tCartProductId);
  });

  test(
    'should return [CartProduct] from the repo',
    () async {
      when(
        () => repo.getCartProduct(
          userId: any(named: "userId"),
          cartProductId: any(named: "cartProductId"),
        ),
      ).thenAnswer((_) async => const Right(tResult));

      final result = await usecase(
        const GetCartProductParams(
          userId: tUserId,
          cartProductId: tCartProductId,
        ),
      );
      expect(result, equals(const Right<dynamic, CartProduct>(tResult)));
      verify(
        () => repo.getCartProduct(
          userId: any(named: "userId"),
          cartProductId: any(named: "cartProductId"),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
