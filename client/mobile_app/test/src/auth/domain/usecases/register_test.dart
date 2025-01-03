import 'package:dartz/dartz.dart';
import 'package:ecomly/src/auth/domain/usecases/register.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late Register usecase;

  const tName = 'Test String';

  const tPassword = 'Test String';

  const tEmail = 'Test String';

  const tPhone = 'Test String';

  setUp(() {
    repo = MockAuthRepo();
    usecase = Register(repo);
    registerFallbackValue(tName);
    registerFallbackValue(tPassword);
    registerFallbackValue(tEmail);
    registerFallbackValue(tPhone);
  });

  test(
    'should call the [AuthRepo.register]',
    () async {
      when(
        () => repo.register(
          name: any(named: "name"),
          password: any(named: "password"),
          email: any(named: "email"),
          phone: any(named: "phone"),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const RegisterParams(
          name: tName,
          password: tPassword,
          email: tEmail,
          phone: tPhone,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.register(
          name: any(named: "name"),
          password: any(named: "password"),
          email: any(named: "email"),
          phone: any(named: "phone"),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
