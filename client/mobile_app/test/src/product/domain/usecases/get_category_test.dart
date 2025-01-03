import 'package:dartz/dartz.dart';
import 'package:ecomly/src/product/domain/entities/category.dart';
import 'package:ecomly/src/product/domain/usecases/get_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'product_repo.mock.dart';

void main() {
  late MockProductRepo repo;
  late GetCategory usecase;

  const tCategoryId = 'Test String';

  const tResult = ProductCategory.empty();

  setUp(() {
    repo = MockProductRepo();
    usecase = GetCategory(repo);
    registerFallbackValue(tCategoryId);
  });

  test(
    'should return [ProductCategory] from the repo',
    () async {
      when(() => repo.getCategory(any())).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(tCategoryId);
      expect(result, equals(const Right<dynamic, ProductCategory>(tResult)));
      verify(() => repo.getCategory(any())).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
