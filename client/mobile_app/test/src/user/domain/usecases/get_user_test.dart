import 'package:dartz/dartz.dart';
import 'package:ecomly/src/user/domain/entities/user.dart';
import 'package:ecomly/src/user/domain/usecases/get_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'user_repo.mock.dart';

void main() {
  late MockUserRepo repo;
  late GetUser usecase;

  const tUserId = 'Test String';

  const tResult = User.empty();

  setUp(() {
    repo = MockUserRepo();
    usecase = GetUser(repo);
    registerFallbackValue(tUserId);
  });

  test(
    'should return [User] from the repo',
    () async {
      when(
        () => repo.getUser(
          any(),
        ),
      ).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(tUserId);
      expect(result, equals(const Right<dynamic, User>(tResult)));
      verify(
        () => repo.getUser(
          any(),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
