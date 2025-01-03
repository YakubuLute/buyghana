import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/order/domain/usecases/get_user_orders.dart';

import 'order_repo.mock.dart';
import 'package:dartz/dartz.dart';
import 'package:ecomly/src/order/domain/entities/order.dart' as model;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late MockOrderRepo repo;
  late GetUserOrders usecase;

  const tUserId = 'Test String';
  final tResult = {
    'total': 1,
    'active': <model.Order>[model.Order.empty()],
    'completed': [],
    'cancelled': [],
  };

  setUp(() {
    repo = MockOrderRepo();
    usecase = GetUserOrders(repo);
    registerFallbackValue(tUserId);
  });

  test(
    'should return [List<Order>] from the repo',
    () async {
      when(
        () => repo.getUserOrders(
          any(),
        ),
      ).thenAnswer(
        (_) async => Right(tResult),
      );

      final result = await usecase(tUserId);
      expect(result, equals(Right<dynamic, DataMap>(tResult)));
      verify(
        () => repo.getUserOrders(
          any(),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
