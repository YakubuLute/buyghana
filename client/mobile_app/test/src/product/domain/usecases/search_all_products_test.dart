import 'package:dartz/dartz.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:ecomly/src/product/domain/usecases/search_all_products.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'product_repo.mock.dart';

void main() {
  late MockProductRepo repo;
  late SearchAllProducts usecase;

  const tQuery = 'Test String';

  const tPage = 1;
  const tResult = <Product>[Product.empty()];

  setUp(() {
    repo = MockProductRepo();
    usecase = SearchAllProducts(repo);
    registerFallbackValue(tQuery);
    registerFallbackValue(tPage);
  });

  test(
    'should return [List<Product>] from the repo',
    () async {
      when(
        () => repo.searchAllProducts(
          query: any(named: "query"),
          page: any(named: "page"),
        ),
      ).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(
        const SearchAllProductsParams(
          query: tQuery,
          page: tPage,
        ),
      );
      expect(result, equals(const Right<dynamic, List<Product>>(tResult)));
      verify(
        () => repo.searchAllProducts(
          query: any(named: "query"),
          page: any(named: "page"),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
