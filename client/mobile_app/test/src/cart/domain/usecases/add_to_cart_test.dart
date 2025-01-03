import 'package:dartz/dartz.dart';
import 'package:ecomly/src/cart/domain/entities/cart_product.dart';
import 'package:ecomly/src/cart/domain/usecases/add_to_cart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'cart_repo.mock.dart';

void main() {
  late MockCartRepo repo;
  late AddToCart usecase;

  const tUserId = 'Test String';

  const tCartProduct = CartProduct.empty();

  setUp(() {
    repo = MockCartRepo();
    usecase = AddToCart(repo);
    registerFallbackValue(tUserId);
    registerFallbackValue(tCartProduct);
  });

  test(
    'should call the [CartRepo.addToCart]',
    () async {
      when(
        () => repo.addToCart(
          userId: any(named: "userId"),
          cartProduct: any(named: "cartProduct"),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const AddToCartParams(
          userId: tUserId,
          cartProduct: tCartProduct,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.addToCart(
          userId: any(named: "userId"),
          cartProduct: any(named: "cartProduct"),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
