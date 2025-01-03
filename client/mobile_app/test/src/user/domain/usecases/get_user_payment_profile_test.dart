import 'package:dartz/dartz.dart';
import 'package:ecomly/src/user/domain/repos/user_repo.dart';
import 'package:ecomly/src/user/domain/usecases/get_user_payment_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'user_repo.mock.dart';

void main() {
  late UserRepo repo;
  late GetUserPaymentProfile usecase;

  const tResult = 'Test String';

  setUp(() {
    repo = MockUserRepo();
    usecase = GetUserPaymentProfile(repo);
  });

  test(
    'should return the [Stripe Payment Profile url] from the [UserRepo]',
    () async {
      when(() => repo.getUserPaymentProfile(any())).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase('userId');

      expect(result, equals(const Right<dynamic, String>(tResult)));
      verify(() => repo.getUserPaymentProfile('userId')).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
