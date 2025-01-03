import 'package:dartz/dartz.dart';
import 'package:ecomly/src/cart/domain/entities/cart_product.dart';
import 'package:ecomly/src/cart/domain/usecases/get_cart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'cart_repo.mock.dart';

void main() {
  late MockCartRepo repo;
  late GetCart usecase;

  const tUserId = 'Test String';
  const tResult = <CartProduct>[CartProduct.empty()];

  setUp(() {
    repo = MockCartRepo();
    usecase = GetCart(repo);
    registerFallbackValue(tUserId);
  });

  test(
    'should return [List<CartProduct>] from the repo',
    () async {
      when(() => repo.getCart(any())).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(tUserId);
      expect(result, equals(const Right<dynamic, List<CartProduct>>(tResult)));
      verify(() => repo.getCart(any())).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
