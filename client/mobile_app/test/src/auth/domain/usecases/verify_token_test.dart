import 'package:dartz/dartz.dart';
import 'package:ecomly/src/auth/domain/usecases/verify_token.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late VerifyToken usecase;

  const tResult = true;

  setUp(() {
    repo = MockAuthRepo();
    usecase = VerifyToken(repo);
  });

  test(
    'should return [bool] from the repo',
    () async {
      when(
        () => repo.verifyToken(),
      ).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase();
      expect(result, equals(const Right<dynamic, bool>(tResult)));
      verify(
        () => repo.verifyToken(),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
