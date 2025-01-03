import 'package:dartz/dartz.dart';
import 'package:ecomly/src/auth/domain/usecases/verify_o_t_p.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late VerifyOTP usecase;

  const tEmail = 'Test String';

  const tOtp = 'Test String';

  setUp(() {
    repo = MockAuthRepo();
    usecase = VerifyOTP(repo);
    registerFallbackValue(tEmail);
    registerFallbackValue(tOtp);
  });

  test(
    'should call the [AuthRepo.verifyOTP]',
    () async {
      when(
        () => repo.verifyOTP(
          email: any(named: "email"),
          otp: any(named: "otp"),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const VerifyOTPParams(
          email: tEmail,
          otp: tOtp,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.verifyOTP(
          email: any(named: "email"),
          otp: any(named: "otp"),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
