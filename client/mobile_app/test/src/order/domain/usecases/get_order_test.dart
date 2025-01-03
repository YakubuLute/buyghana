import 'package:dartz/dartz.dart';
import 'package:ecomly/src/order/domain/entities/order.dart' as model;
import 'package:ecomly/src/order/domain/usecases/get_order.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'order_repo.mock.dart';

void main() {
  late MockOrderRepo repo;
  late GetOrder usecase;

  const tOrderId = 'Test String';

  final tResult = model.Order.empty();

  setUp(() {
    repo = MockOrderRepo();
    usecase = GetOrder(repo);
    registerFallbackValue(tOrderId);
  });

  test(
    'should return [Order] from the repo',
    () async {
      when(
        () => repo.getOrder(
          any(),
        ),
      ).thenAnswer(
        (_) async => Right(tResult),
      );

      final result = await usecase(tOrderId);
      expect(result, equals(Right<dynamic, model.Order>(tResult)));
      verify(
        () => repo.getOrder(
          any(),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
