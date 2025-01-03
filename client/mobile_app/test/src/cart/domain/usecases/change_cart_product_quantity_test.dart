import 'package:dartz/dartz.dart';
import 'package:ecomly/src/cart/domain/usecases/change_cart_product_quantity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'cart_repo.mock.dart';

void main() {
  late MockCartRepo repo;
  late ChangeCartProductQuantity usecase;

  const tUserId = 'Test String';

  const tCartProductId = 'Test String';

  const tNewQuantity = 1;

  setUp(() {
    repo = MockCartRepo();
    usecase = ChangeCartProductQuantity(repo);
    registerFallbackValue(tUserId);
    registerFallbackValue(tCartProductId);
    registerFallbackValue(tNewQuantity);
  });

  test(
    'should call the [CartRepo.changeCartProductQuantity]',
    () async {
      when(
        () => repo.changeCartProductQuantity(
          userId: any(named: "userId"),
          cartProductId: any(named: "cartProductId"),
          newQuantity: any(named: "newQuantity"),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const ChangeCartProductQuantityParams(
          userId: tUserId,
          cartProductId: tCartProductId,
          newQuantity: tNewQuantity,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.changeCartProductQuantity(
          userId: any(named: "userId"),
          cartProductId: any(named: "cartProductId"),
          newQuantity: any(named: "newQuantity"),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
