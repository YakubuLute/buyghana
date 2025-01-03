import 'package:dartz/dartz.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:ecomly/src/product/domain/usecases/search_by_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'product_repo.mock.dart';

void main() {
  late MockProductRepo repo;
  late SearchByCategory usecase;

  const tQuery = 'Test String';

  const tCategoryId = 'Test String';

  const tPage = 1;
  const tResult = <Product>[Product.empty()];

  setUp(() {
    repo = MockProductRepo();
    usecase = SearchByCategory(repo);
    registerFallbackValue(tQuery);
    registerFallbackValue(tCategoryId);
    registerFallbackValue(tPage);
  });

  test(
    'should return [List<Product>] from the repo',
    () async {
      when(
        () => repo.searchByCategory(
          query: any(named: "query"),
          categoryId: any(named: "categoryId"),
          page: any(named: "page"),
        ),
      ).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(
        const SearchByCategoryParams(
          query: tQuery,
          categoryId: tCategoryId,
          page: tPage,
        ),
      );
      expect(result, equals(const Right<dynamic, List<Product>>(tResult)));
      verify(
        () => repo.searchByCategory(
          query: any(named: "query"),
          categoryId: any(named: "categoryId"),
          page: any(named: "page"),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
