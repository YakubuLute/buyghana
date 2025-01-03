import 'package:dartz/dartz.dart';
import 'package:ecomly/src/auth/domain/usecases/login.dart';
import 'package:ecomly/src/user/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late Login usecase;

  const tEmail = 'Test String';

  const tPassword = 'Test String';

  const tResult = User.empty();

  setUp(() {
    repo = MockAuthRepo();
    usecase = Login(repo);
    registerFallbackValue(tEmail);
    registerFallbackValue(tPassword);
  });

  test(
    'should return [User] from the repo',
    () async {
      when(
        () => repo.login(
          email: any(named: "email"),
          password: any(named: "password"),
        ),
      ).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(
        const LoginParams(
          email: tEmail,
          password: tPassword,
        ),
      );
      expect(result, equals(const Right<dynamic, User>(tResult)));
      verify(
        () => repo.login(
          email: any(named: "email"),
          password: any(named: "password"),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
