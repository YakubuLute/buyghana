import 'package:dartz/dartz.dart';
import 'package:ecomly/src/cart/domain/usecases/get_cart_count.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'cart_repo.mock.dart';

void main() {
  late MockCartRepo repo;
  late GetCartCount usecase;

  const tUserId = 'Test String';

  const tResult = 1;

  setUp(() {
    repo = MockCartRepo();
    usecase = GetCartCount(repo);
    registerFallbackValue(tUserId);
  });

  test(
    'should return [int] from the repo',
    () async {
      when(() => repo.getCartCount(any())).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(tUserId);
      expect(result, equals(const Right<dynamic, int>(tResult)));
      verify(() => repo.getCartCount(any())).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
