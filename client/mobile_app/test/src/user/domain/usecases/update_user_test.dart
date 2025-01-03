import 'package:dartz/dartz.dart';
import 'package:ecomly/src/user/domain/entities/user.dart';
import 'package:ecomly/src/user/domain/usecases/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'user_repo.mock.dart';

void main() {
  late MockUserRepo repo;
  late UpdateUser usecase;

  const tUserId = 'Test String';

  const tUpdateData = <String, dynamic>{};

  const tResult = User.empty();

  setUp(() {
    repo = MockUserRepo();
    usecase = UpdateUser(repo);
    registerFallbackValue(tUserId);
    registerFallbackValue(tUpdateData);
  });

  test(
    'should return [User] from the repo',
    () async {
      when(
        () => repo.updateUser(
          userId: any(named: "userId"),
          updateData: any(named: "updateData"),
        ),
      ).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(
        const UpdateUserParams(
          userId: tUserId,
          updateData: tUpdateData,
        ),
      );
      expect(result, equals(const Right<dynamic, User>(tResult)));
      verify(
        () => repo.updateUser(
          userId: any(named: "userId"),
          updateData: any(named: "updateData"),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
