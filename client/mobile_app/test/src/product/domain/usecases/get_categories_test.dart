import 'package:dartz/dartz.dart';
import 'package:ecomly/src/product/domain/entities/category.dart';
import 'package:ecomly/src/product/domain/usecases/get_categories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'product_repo.mock.dart';

void main() {
  late MockProductRepo repo;
  late GetCategories usecase;
  const tResult = <ProductCategory>[ProductCategory.empty()];

  setUp(() {
    repo = MockProductRepo();
    usecase = GetCategories(repo);
  });

  test(
    'should return [List<ProductCategory>] from the repo',
    () async {
      when(() => repo.getCategories()).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase();
      expect(
        result,
        equals(const Right<dynamic, List<ProductCategory>>(tResult)),
      );
      verify(() => repo.getCategories()).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
