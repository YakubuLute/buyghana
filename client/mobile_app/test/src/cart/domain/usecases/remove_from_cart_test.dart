import 'package:dartz/dartz.dart';
import 'package:ecomly/src/cart/domain/usecases/remove_from_cart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'cart_repo.mock.dart';

void main() {
  late MockCartRepo repo;
  late RemoveFromCart usecase;

  const tUserId = 'Test String';

  const tCartProductId = 'Test String';

  setUp(() {
    repo = MockCartRepo();
    usecase = RemoveFromCart(repo);
    registerFallbackValue(tUserId);
    registerFallbackValue(tCartProductId);
  });

  test(
    'should call the [CartRepo.removeFromCart]',
    () async {
      when(
        () => repo.removeFromCart(
          userId: any(named: "userId"),
          cartProductId: any(named: "cartProductId"),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const RemoveFromCartParams(
          userId: tUserId,
          cartProductId: tCartProductId,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.removeFromCart(
          userId: any(named: "userId"),
          cartProductId: any(named: "cartProductId"),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
