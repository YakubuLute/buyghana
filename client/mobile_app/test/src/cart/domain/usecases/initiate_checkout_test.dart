import 'package:dartz/dartz.dart';
import 'package:ecomly/src/cart/data/models/cart_product_model.dart';
import 'package:ecomly/src/cart/domain/repos/cart_repo.dart';
import 'package:ecomly/src/cart/domain/usecases/initiate_checkout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'cart_repo.mock.dart';

void main() {
  late CartRepo repo;
  late InitiateCheckout usecase;

  const tResult = 'https://stripe-test-checkout.com';

  setUp(() {
    repo = MockCartRepo();
    usecase = InitiateCheckout(repo);
  });

  test(
    'should return the [Stripe Checkout url] from the [CartRepo]',
    () async {
      const tCartItems = [CartProductModel.empty()];
      when(
        () => repo.initiateCheckout(
          theme: any(named: 'theme'),
          cartItems: any(named: 'cartItems'),
        ),
      ).thenAnswer((_) async => const Right(tResult));

      final result = await usecase(const InitiateCheckoutParams(
        theme: 'theme',
        cartItems: tCartItems,
      ));

      expect(result, equals(const Right<dynamic, String>(tResult)));

      verify(
        () => repo.initiateCheckout(theme: 'theme', cartItems: tCartItems),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
