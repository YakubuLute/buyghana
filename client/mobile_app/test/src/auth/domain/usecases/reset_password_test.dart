import 'package:dartz/dartz.dart';
import 'package:ecomly/src/auth/domain/usecases/reset_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late ResetPassword usecase;

  const tEmail = 'Test String';

  const tNewPassword = 'Test String';

  setUp(() {
    repo = MockAuthRepo();
    usecase = ResetPassword(repo);
    registerFallbackValue(tEmail);
    registerFallbackValue(tNewPassword);
  });

  test(
    'should call the [AuthRepo.resetPassword]',
    () async {
      when(
        () => repo.resetPassword(
          email: any(named: "email"),
          newPassword: any(named: "newPassword"),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const ResetPasswordParams(
          email: tEmail,
          newPassword: tNewPassword,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.resetPassword(
          email: any(named: "email"),
          newPassword: any(named: "newPassword"),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
